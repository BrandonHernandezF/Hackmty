
from llama_cpp import Llama
import os
import re
import threading
import time
import sys

# Regex para capturar fragmentos de código generados por el modelo
PATTERN = r"```(html|css|javascript)\n([\s\S]*?)\n```"
MODEL_PATH = r"C:\Users\Naexwk\Desktop\llama\Llama3-OpenBioLLM-8B"

# Inicialización y retorno del modelo!
def init_model(filepath : str) -> Llama:
    # Setup de bajo rendimiento en tarjeta gráfica
    model = Llama(
        model_path = filepath, # archivo .gguf de HuggingFace
        n_gpu_layers = 0, # No se utiliza GPU, solo CPU y RAM
        use_mmap = True, # Dado que no se cuenta con una GPU dedicada, se aprovecha el
                        # exceso de 40 GB de RAM para compensar.
        n_ctx=4066, # Tamaño del contexto (número de tokens)
        verbose = False # Silenciar la información detallada de la ejecución
    )

    return model

def get_snippets(prompt : str, model : Llama):

    # El promptEnhancer es necesario para forzar que el modelo no se 'aloque' con cosas aleatorias
    # Sería un auxiliar de la propiedad ´temperature´, para guiar al modelo a solo generar el código necesario.

    promptEnhancer = "You are a doctor and"

    output = model(
        f"You are a doctor and a patient describes their symptoms as \"{prompt}\". What do you recommend? \\end:",  # Se le apendiza al prompt en formato 'string'
        max_tokens=300,  # Número máximo de tokens a generar
        stop=["\\end"],  # Token de parada para finalizar la generación
        temperature=0.1,  # Temperatura para controlar la aleatoriedad en la generación
        repeat_penalty=1.2,  # Penalización para evitar repeticiones en el texto generado
        top_p=0.85,  # Muestreo nucleus para seleccionar los tokens más probables
        frequency_penalty=0.5  # Penalización para reducir la frecuencia de tokens repetidos
    )


    # Obtener el texto generado por el modelo
    modelResponse = output["choices"][0]["text"]


    # Extraer los fragmentos de código utilizando el patrón de expresión regular
    codeSnippets = re.findall(PATTERN, modelResponse)
    cleanDict = {}
    
    # Almacena los fragmentos de código en un diccionario, organizados por lenguaje.
    for lang, code in codeSnippets:
        if lang not in cleanDict:  # Si el lenguaje no está en el diccionario
            cleanDict[lang] = code  # Agregar el fragmento de código al diccionario
    return cleanDict


def clear_screen():
    if os.name == 'nt':  # Windows
        os.system('cls')
    else:  # Unix/Linux/macOS
        os.system('clear')

# Animación de carga durante la generación de código.
def loading_animation(event):
    while not event.is_set(): 
        for i in range(4):  # Ciclo para los puntos suspensivos animados de 0 a 3 
            sys.stdout.write(f"\rGenerating{'.' * i}")
            sys.stdout.flush()
            time.sleep(0.5)  # Ajusta para animación más rápida o más lenta
        sys.stdout.write("\rGenerating   ")  # Limpia los puntos al final del ciclo
    sys.stdout.write("\r" + " " * 20 + "\r")  

# Controla la carga y la visualización de los fragmentos de código generados.
def fetch_snippets(prompt, model_path):
    event = threading.Event()
    loader = threading.Thread(target=loading_animation, args=(event,))
    loader.start()

    try:
        time.sleep(2)  
        modelGenCode = get_snippets(prompt, init_model(model_path))
        event.set() 
        loader.join() 
        print(f"""Text2UI>\nHTML:\n{modelGenCode["html"]}\n
CSS:\n{modelGenCode["css"]}\n
JavaScript:\n{modelGenCode["javascript"]}""")
    except Exception as e:
        print(f"Error al obtener los datos: {e}")
        event.set()
        loader.join()

print("Ctrl + C to exit CLI\n")

while True:
    try:
        prompt = input("User> ").strip()
        if prompt.lower() == 'clean' or prompt.lower() == 'clear': # CLEAN/clean y CLEAR/clear: limpian la pantalla
            clear_screen()
        elif prompt:
            fetch_snippets(prompt, MODEL_PATH)  # Asegúrate de definir modelPath correctamente
    except KeyboardInterrupt:
        print("\nLoggin out...")
        break