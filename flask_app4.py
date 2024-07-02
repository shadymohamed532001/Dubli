import re
from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import threading
import time
import json
from transformers import BartTokenizer, BartForConditionalGeneration, AutoModelForCausalLM, AutoTokenizer
import os
import uuid
from gtts import gTTS
import speech_recognition as sr
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
import joblib


app = Flask(__name__)
CORS(app)  # Allow Cross-Origin Resource Sharing (CORS)


# Global variables for loading status and models
loading_lock = threading.Lock()  # Lock for synchronizing access to loading status
qwen_loading_flag = False  # Flag to indicate if loading is in progress
qwen_tokenizer = None  # Global variable for tokenizer
qwen_model = None  # Global variable for model
bart_loading_flag = False  # Flag to indicate if loading is in progress
bart_tokenizer = None  # Global variable for tokenizer
bart_model = None  # Global variable for model

# Global variables for speech recognition
is_recording = False
recorded_text = ""
recognizer = sr.Recognizer()

# Dictionary to store chat histories for each user
chat_histories = {}
current_chat_ids = {}


# Function to check if the concentration model exists
def load_or_create_concentration_model():
    model_filename = 'concentration_model.pkl'
    dataset_filename = 'concentration_dataset_adjusted_age_ranges.csv'

    if os.path.exists(model_filename):
        # Load the existing model
        model = joblib.load(model_filename)
        print("Existing concentration model loaded.")
    else:
        # Generate the dataset if it doesn't exist
        if not os.path.exists(dataset_filename):
            print("Generating concentration dataset...")
            # Define the number of records you want
            num_records = 10000  # You can adjust this number based on your needs

            # Generate random data
            np.random.seed(0)  # For reproducibility

            # Generate age (assuming ages between 10 and 70)
            age = np.random.randint(10, 71, size=num_records)

            # Generate gender (0 for male, 1 for female)
            gender = np.random.randint(0, 2, size=num_records)

            # Generate focus level (assuming levels from 1 to 5)
            focus_level = np.random.randint(1, 6, size=num_records)

            # Adjust minutes of concentration based on age, gender, and focus level
            minutes_concentrate = np.zeros(num_records)

            for i in range(num_records):

                if gender[i] == 0:  # Male
                    if focus_level[i] == 1:
                        minutes_adjustment = np.random.randint(60, 121)

                    elif focus_level[i] == 2:
                        minutes_adjustment = np.random.randint(121, 222)

                    elif focus_level[i] == 3:
                        minutes_adjustment = np.random.randint(222, 323)

                    elif focus_level[i] == 4:
                        minutes_adjustment = np.random.randint(323, 424)

                    elif focus_level[i] == 5:
                        minutes_adjustment = np.random.randint(424, 481)

                else:  # Female
                    if focus_level[i] == 1:
                        minutes_adjustment = np.random.randint(62, 123)

                    elif focus_level[i] == 2:
                        minutes_adjustment = np.random.randint(123, 224)

                    elif focus_level[i] == 3:
                        minutes_adjustment = np.random.randint(224, 325)

                    elif focus_level[i] == 4:
                        minutes_adjustment = np.random.randint(325, 426)

                    elif focus_level[i] == 5:
                        minutes_adjustment = np.random.randint(426, 483)

                minutes_concentrate[i] = minutes_adjustment

            # Create a DataFrame
            df_concentration = pd.DataFrame({
                'Age': age,
                'Gender': gender,
                'Focus_Level': focus_level,
                # Convert to integer
                'Minutes_Concentrate': minutes_concentrate.astype(int)
            })

            # Save the dataset
            df_concentration.to_csv(dataset_filename, index=False)
            print(f"Concentration dataset saved to {dataset_filename}")

        # Load the dataset
        df_concentration = pd.read_csv(dataset_filename)

        # Separate features (X) and target (y)
        X = df_concentration[['Age', 'Gender', 'Focus_Level']]
        y = df_concentration['Minutes_Concentrate']

        # Split the data into training and testing sets (80% train, 20% test)
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=0)

        # Train a linear regression model
        model = LinearRegression()
        model.fit(X_train, y_train)

        # Save the trained model using joblib
        joblib.dump(model, model_filename)
        print(f"Concentration model trained and saved to {model_filename}")

    return model


# Load or create the concentration model
model = load_or_create_concentration_model()


# Define a route for predicting concentration minutes
@app.route('/predict_focus', methods=['POST'])
def predict_concentration():
    # Get data from the request
    data = request.get_json()

    # Extract age, gender, and focus level from the request data
    age = data['age']
    gender = data['gender']
    gender = 1 if gender.lower() == 'female' else 0
    focus_level = data['focus_level']
    if focus_level > 5:
        focus_level = 5
    elif focus_level < 1:
        focus_level = 1

    # Function to predict concentration minutes for given age, gender, and focus level
    def predict_minutes(model, age, gender, focus_level):
        # Create a DataFrame for prediction
        df_pred = pd.DataFrame({
            'Age': [age],
            'Gender': [gender],
            'Focus_Level': [focus_level]
        })
        # Predict using the trained model
        minutes_prediction = model.predict(df_pred)
        # Round to the nearest integer
        rounded_minutes = round(minutes_prediction[0])
        return rounded_minutes

    # Predict concentration minutes
    predicted_minutes = predict_minutes(model, age, gender, focus_level)

    print(f"Age {age}, Gender {'Female' if gender == 1 else 'Male'}, Focus Level {focus_level}: {predicted_minutes} minutes")

    # Prepare response data
    response = {
        'predicted_minutes': predicted_minutes
    }

    return jsonify(response)

def load_qwen_model():
    global qwen_loading_flag, qwen_tokenizer, qwen_model

    if qwen_tokenizer is not None and qwen_model is not None:
        print("Qwen model and tokenizer are already loaded.")
        return

    with loading_lock:
        if qwen_loading_flag:
            print("Qwen loading is already in progress.")
            return
        qwen_loading_flag = True

    try:
        device = "cpu"

        qwen_model = AutoModelForCausalLM.from_pretrained(
            "Qwen/Qwen1.5-0.5B-Chat",
            torch_dtype="auto",
        )
        qwen_tokenizer = AutoTokenizer.from_pretrained(
            "Qwen/Qwen1.5-0.5B-Chat"
        )

        qwen_model.to("cpu")

        print("Qwen model and tokenizer loaded successfully.")
    except Exception as e:
        print("Error loading Qwen model:", e)
    finally:
        with loading_lock:
            qwen_loading_flag = False


def load_bart_model():
    global bart_loading_flag, bart_tokenizer, bart_model

    if bart_tokenizer is not None and bart_model is not None:
        print("BART model and tokenizer are already loaded.")
        return

    with loading_lock:
        if bart_loading_flag:
            print("BART loading is already in progress.")
            return
        bart_loading_flag = True

    try:
        print("Loading BART model and tokenizer...")
        model_path = "facebook/bart-large-cnn"
        tokenizer_path = "facebook/bart-large-cnn"

        bart_tokenizer = BartTokenizer.from_pretrained(tokenizer_path)
        bart_model = BartForConditionalGeneration.from_pretrained(model_path)

        print("BART model and tokenizer loaded successfully.")
    except Exception as e:
        print("Error loading BART model:", e)
    finally:
        with loading_lock:
            bart_loading_flag = False


qwen_thread = None
bart_thread = None


def start_loading_threads():
    global qwen_thread, bart_thread

    if not qwen_thread or not qwen_thread.is_alive():
        qwen_thread = threading.Thread(target=load_qwen_model)
        qwen_thread.start()

    if not bart_thread or not bart_thread.is_alive():
        bart_thread = threading.Thread(target=load_bart_model)
        bart_thread.start()


start_loading_threads()


def save_chat_history(user_id, chat_id):
    if user_id in chat_histories and chat_id:
        chat_session = next(
            (chat for chat in chat_histories[user_id] if chat["id"] == chat_id), None)
        if chat_session:
            file_name = f"chat_history_{user_id}_{chat_id}.json"
            with open(file_name, 'w') as f:
                json.dump(chat_session, f, indent=4)


@app.route('/chatbot', methods=['POST'])
def chatbot():
    try:
        data = request.json
        user_input = data["message"].lower()
        response_type = data.get("response_type", "text")

        if "summarize" in user_input or "summary" in user_input or "summarization" in user_input:
            return summarize()
        else:
            return chat()
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/summarize', methods=['POST'])
def summarize():
    global bart_tokenizer, bart_model

    data = request.json
    user_input = data.get('message')
    user_id = data.get('user_id')
    response_type = data.get("response_type", "text")
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    while bart_tokenizer is None or bart_model is None:
        print("Waiting for BART model and tokenizer to be loaded...")
        time.sleep(3)

    try:
        print("Tokenizing input...")
        inputs = bart_tokenizer(
            user_input, max_length=1024, return_tensors="pt", truncation=True)

        print("Generating summary...")
        summary_ids = bart_model.generate(
            inputs["input_ids"], num_beams=4, max_length=150, early_stopping=True)
        summary = bart_tokenizer.decode(
            summary_ids[0], skip_special_tokens=True)

        print("Summary: ", summary)

        chat_id = current_chat_ids.get(user_id)
        if not chat_id:
            chat_id = str(uuid.uuid4())
            current_chat_ids[user_id] = chat_id
            chat_histories[user_id] = []

        chat_session = next(
            (chat for chat in chat_histories[user_id] if chat["id"] == chat_id), None)
        if chat_session:
            chat_session["messages"].append(
                {"user": user_input, "assistant": summary})
        else:
            chat_histories[user_id].append({
                "id": chat_id,
                "messages": [{"user": user_input, "assistant": summary}]
            })

        save_chat_history(user_id, chat_id)

        if response_type == "audio":
            audio_file = generate_audio(summary)
            return send_file(audio_file, as_attachment=True)

        return jsonify({'response': summary})
    except Exception as e:
        return jsonify({'error': str(e)})


@app.route('/chat', methods=['POST'])
def chat():
    global chat_histories, current_chat_ids

    data = request.json
    user_id = data.get('user_id')
    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    while qwen_tokenizer is None or qwen_model is None:
        print("Waiting for Qwen model and tokenizer to be loaded...")
        time.sleep(3)

    try:
        user_input = data["message"]

        print("question: ", user_input)

        messages = [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": user_input}
        ]
        text = qwen_tokenizer.apply_chat_template(
            messages,
            tokenize=False,
            add_generation_prompt=True
        )
        model_inputs = qwen_tokenizer([text], return_tensors="pt").to("cpu")

        generated_ids = qwen_model.generate(
            model_inputs.input_ids,
            max_new_tokens=512
        )
        generated_ids = [
            output_ids[len(input_ids):] for input_ids, output_ids in zip(model_inputs.input_ids, generated_ids)
        ]

        response = qwen_tokenizer.batch_decode(
            generated_ids, skip_special_tokens=True)[0]

        # Remove non-ASCII characters
        response = re.sub(r'[^\x00-\x7F]+', '', response)

        # Replace "Qwen" with "Dupli"
        response = response.replace("Qwen", "Dupli")

        # Replace "Alibaba Cloud" with "AASTIANS"
        response = response.replace(
            "Alibaba Cloud", "AASTIANS using alogorithms and pretrained models such as Qwen that was created by Alibaba Cloud.")

        # Add explanation after "Dupli because" and remove anything that was after it
        response = re.sub(r'(Dupli because).*',
                          r'\1 it is inspired by the word Duplicate.', response)

        print("response: ", response)

        chat_id = current_chat_ids.get(user_id)
        if not chat_id:
            chat_id = str(uuid.uuid4())
            current_chat_ids[user_id] = chat_id
            chat_histories[user_id] = []

        chat_session = next(
            (chat for chat in chat_histories[user_id] if chat["id"] == chat_id), None)
        if chat_session:
            chat_session["messages"].append(
                {"user": user_input, "assistant": response})
        else:
            chat_histories[user_id].append({
                "id": chat_id,
                "messages": [{"user": user_input, "assistant": response}]
            })

        save_chat_history(user_id, chat_id)

        response_type = data.get("response_type", "text")
        if response_type == "audio":
            audio_file = generate_audio(response)
            return send_file(audio_file, as_attachment=True)

        return jsonify({"response": response, "chat_id": chat_id}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/startchat', methods=['POST'])
def start_chat():
    data = request.json
    user_id = data.get('user_id')

    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    chat_id = str(uuid.uuid4())
    current_chat_ids[user_id] = chat_id
    chat_histories.setdefault(user_id, []).append(
        {"id": chat_id, "messages": []})

    return jsonify({"message": "New chat session started.", "chat_id": chat_id}), 200


@app.route('/endchat', methods=['POST'])
def end_chat():
    data = request.json
    user_id = data.get('user_id')

    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    chat_id = current_chat_ids.pop(user_id, None)
    if not chat_id:
        return jsonify({"error": "No active chat session found for this user."}), 404

    save_chat_history(user_id, chat_id)
    return jsonify({"message": "Chat session ended."}), 200


@app.route('/chathistory', methods=['GET'])
def chat_history():
    user_id = request.args.get('user_id')
    chat_id = request.args.get('chat_id')

    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    user_chats = chat_histories.get(user_id, [])

    if chat_id:
        chat_session = next(
            (chat for chat in user_chats if chat["id"] == chat_id), None)
        if chat_session:
            return jsonify({"chats": [chat_session]}), 200
        else:
            return jsonify({"error": "Chat session not found."}), 404

    return jsonify({"chats": user_chats}), 200


@app.route('/startrecording', methods=['POST'])
def start_recording():
    global is_recording, recorded_text

    if is_recording:
        return jsonify({"message": "Recording is already in progress."}), 400

    is_recording = True
    recorded_text = ""
    threading.Thread(target=record_audio).start()

    return jsonify({"message": "Recording started"}), 200


@app.route('/stoprecording', methods=['POST'])
def stop_recording():
    global is_recording

    if not is_recording:
        return jsonify({"message": "No recording in progress."}), 400

    is_recording = False

    while recorded_text == "":
        time.sleep(1)

    # Prepare the data to send to the chatbot function
    data = {
        'user_id': request.json.get('user_id'),
        'message': recorded_text,
        'response_type': request.json.get('response_type', 'text')
    }

    # Simulate a POST request to the chatbot endpoint with the prepared data
    with app.test_request_context('/chatbot', method='POST', json=data):
        # Call the chatbot function directly
        return chatbot()


def record_audio():
    global recorded_text

    with sr.Microphone() as source:
        recognizer.adjust_for_ambient_noise(source)
        print("Recording...")

        audio = recognizer.listen(source)

        try:
            print("Recognizing...")
            recorded_text = recognizer.recognize_google(audio)
            print("Recorded text: ", recorded_text)
        except sr.UnknownValueError:
            print("Google Speech Recognition could not understand audio")
            recorded_text = ""
        except sr.RequestError as e:
            print(
                "Could not request results from Google Speech Recognition service; {0}".format(e))
            recorded_text = ""


def send_text_to_chatbot(user_id, text, response_type):
    try:
        # Prepare the data as it would be received by the chatbot endpoint
        data = {
            "user_id": user_id,
            "message": text,
            "response_type": response_type
        }

        # Use Flask's test client to simulate a request to the chatbot endpoint
        with app.test_client() as client:
            response = client.post('/chatbot', json=data)
            response_data = response.get_json()
            return response_data.get("response")
    except Exception as e:
        print("Error sending text to chatbot:", str(e))
        return str(e)


def generate_audio(text, slow=False):
    try:
        tts = gTTS(text=text, lang='en', slow=slow)
        filename = 'response.mp3'
        filepath = os.path.join(os.getcwd(), filename)
        tts.save(filepath)
        return filepath
    except Exception as e:
        print("Error generating audio:", str(e))
        return None


# Load chat histories from JSON files


def load_chat_histories():
    global chat_histories, current_chat_ids
    for file_name in os.listdir('.'):
        if file_name.startswith('chat_history_') and file_name.endswith('.json'):
            with open(file_name, 'r') as f:
                chat_history = json.load(f)
                user_id = file_name.split('_')[2]
                chat_histories.setdefault(user_id, []).append(chat_history)
                current_chat_ids[user_id] = chat_history["id"]


load_chat_histories()


def save_chat_history(user_id, chat_id):
    if user_id in chat_histories and chat_id:
        chat_session = next(
            (chat for chat in chat_histories[user_id] if chat["id"] == chat_id), None)
        if chat_session:
            file_name = f"chat_history_{user_id}_{chat_id}.json"
            with open(file_name, 'w') as f:
                json.dump(chat_session, f, indent=4)


# @app.route('/uploadaudio', methods=['POST'])
# def upload_audio():
#     try:
#         # Parse JSON data from the request
#         file_path = request.json.get('file_path')
#         user_id = request.json.get('user_id')
#         metadata = request.json.get('metadata')

#         if file_path and file_path.endswith('.mp3'):
#             # Create a path for the WAV file in the temporary directory
#             wav_file_path = os.path.join(tempfile.gettempdir(), "outputtt.wav")

#             # Convert MP3 to WAV using MoviePy
#             audio_clip = AudioFileClip(file_path)
#             audio_clip.write_audiofile(wav_file_path)
#             audio_clip.close()

#             # Generate a unique filename for saving the uploaded audio
#             audio_filename = 'vn.wav'
#             audio_path = os.path.join('uploads', audio_filename)

#             # Ensure the uploads directory exists
#             os.makedirs('uploads', exist_ok=True)

#             # If the target file already exists, remove it
#             if os.path.exists(audio_path):
#                 os.remove(audio_path)

#             # Save the converted WAV file to the 'uploads' directory
#             os.rename(wav_file_path, audio_path)

#             # Transcribe the audio file
#             text = transcribe_audio_to_text(audio_path)
#             print(text)

#             if metadata:
#                 metadata = json.loads(metadata)
#                 print("Parsed Metadata: ", metadata)

#             # Prepare data to send to the chatbot function
#             data = {
#                 'user_id': user_id,
#                 'message': text,
#             }

#             # Simulate a POST request to the chatbot endpoint with the prepared data
#             with app.test_request_context('/chatbot', method='POST', json=data):
#                 # Call the chatbot function directly
#                 return chatbot()

#         else:
#             return jsonify({"error": "No valid MP3 audio file found"}), 400

#     except Exception as e:
#         return jsonify({"error": str(e)}), 500


def transcribe_audio_to_text(audio_path):
    try:
        with sr.AudioFile(audio_path) as source:
            audio_data = recognizer.record(source)
            return recognizer.recognize_google(audio_data)
    except Exception as e:
        print("Error transcribing audio:", str(e))
        return ""


if __name__ == '__main__':
    app.run(debug=False)
