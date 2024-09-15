from llama_cpp import Llama
import os
import threading
import time

MODEL_PATH = r"C:\Users\Naexwk\Desktop\llama\openbiollm-llama3-8b.Q8_0.gguf"

def init_model(filepath : str) -> Llama:
    model = Llama(
        model_path = filepath, # archivo .gguf de HuggingFace
        n_gpu_layers = -1, 
        use_mmap = True, 
        n_ctx=4066,
        verbose = False
    )

    return model

def get_snippets(prompt : str, model : Llama):

    output = model(
        f"A doctor evaluates the patient's condition based on their complaints: {prompt}. The doctor provides a diagnosis, suggests a specific treatment plan offering at least 3 distinct recommendations for recovery. The doctor does not ask further questions, name medicaments, or suggest additional tests. Doctor's response:",
        max_tokens=600,  
        stop=["\\end"],  
        temperature=0.1,  
        repeat_penalty=1.2, 
        top_p=0.85, 
        frequency_penalty=0.3 
    )


    # Obtener el texto generado por el modelo
    modelResponse = output["choices"][0]["text"]

    return modelResponse


def clear_screen():
    if os.name == 'nt':
        os.system('cls')

def fetch_snippets(prompt, model_path):
    event = threading.Event()
    try:
        time.sleep(2)  
        modelGenCode = get_snippets(prompt, init_model(model_path))
        event.set() 
        return modelGenCode
    except Exception as e:
        print(f"Error al obtener los datos: {e}")
        event.set()

def prompt(promptString):
    return fetch_snippets(promptString, MODEL_PATH)