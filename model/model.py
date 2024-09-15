
from llama_cpp import Llama
import os
import threading
import time
import sys

# Regex para capturar fragmentos de código generados por el modelo
PATTERN = r"*"
MODEL_PATH = r"C:\Users\Naexwk\Desktop\llama\openbiollm-llama3-8b.Q8_0.gguf"

# Inicialización y retorno del modelo!
def init_model(filepath : str) -> Llama:
    # Setup de bajo rendimiento en tarjeta gráfica
    model = Llama(
        model_path = filepath, # archivo .gguf de HuggingFace
        n_gpu_layers = -1, # No se utiliza GPU, solo CPU y RAM
        use_mmap = True, # Dado que no se cuenta con una GPU dedicada, se aprovecha el    # exceso de 40 GB de RAM para compensar.
        n_ctx=4066, # Tamaño del contexto (número de tokens)
        verbose = False # Silenciar la información detallada de la ejecución
    )

    return model

def get_snippets(prompt : str, model : Llama):

    # El promptEnhancer es necesario para forzar que el modelo no se 'aloque' con cosas aleatorias
    # Sería un auxiliar de la propiedad ´temperature´, para guiar al modelo a solo generar el código necesario.

    output = model(
        f"A doctor evaluates the patient's condition based on their complaints: {prompt}. The doctor provides a diagnosis, suggests a specific treatment plan offering at least 3 distinct recommendations for recovery. The doctor does not ask further questions, name medicaments, or suggest additional tests. Doctor's response:",
        max_tokens=600,  # Número máximo de tokens a generar
        stop=["\\end"],  # Token de parada para finalizar la generación
        temperature=0.1,  # Temperatura para controlar la aleatoriedad en la generación
        repeat_penalty=1.2,  # Penalización para evitar repeticiones en el texto generado
        top_p=0.85,  # Muestreo nucleus para seleccionar los tokens más probables
        frequency_penalty=0.3 # Penalización para reducir la frecuencia de tokens repetidos
    )


    # Obtener el texto generado por el modelo
    modelResponse = output["choices"][0]["text"]#.split('|')

    return modelResponse


def clear_screen():
    if os.name == 'nt':  # Windows
        os.system('cls')
    else:  # Unix/Linux/macOS
        os.system('clear')

# Controla la carga y la visualización de los fragmentos de código generados.
def fetch_snippets(prompt, model_path):
    event = threading.Event()
    #loader = threading.Thread(target=loading_animation, args=(event,))
    #loader.start()
    try:
        time.sleep(2)  
        modelGenCode = get_snippets(prompt, init_model(model_path))
        event.set() 
        #loader.join() 
        return modelGenCode
        print(modelGenCode)
    except Exception as e:
        print(f"Error al obtener los datos: {e}")
        event.set()
        #loader.join()

def prompt(promptString):
    return fetch_snippets(promptString, MODEL_PATH)