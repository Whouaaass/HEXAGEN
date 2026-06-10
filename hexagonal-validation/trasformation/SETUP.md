# Configuración del entorno de generación con IA

Se uso un agente (Opencode con DeepSeek V4 Flash Free (medium)), y para cada prompt se creó una nueva sesión sin contexto previo, además se revisó que el agente no tocara ningun otro archivo ni hiciera "exploraciones"

Se crearon unos metamodelos ejemplo de forma sencilla instanceando todas las cosas que tenia un metamodelo y completando sus atributos en el modelo de forma ordenada, correcta y validada para que la IA pudiera generar el .xmi sin errores
## Prompt para conversión Híbrida

El prompt para convertir un modelo .xmi desde el metamodelo hmm a smm, fue

```
In the context of Epsilon
Transform the next input model based on the metamodel `hmm` to a model based on the metamodel `smm`

input metamodel (hmm): @models/hmm.ecore 
input model (hmm): @models/LibraryLoanSystem.xmi 
example model (smm): @models/smm-example.xmi 
smm metamodel: @models/smm.ecore 

The expected output is a model based in the metamodel smm, written in a .xmi file with the name of <base_name>-smm-hybrid.xmi, use example model to follow the structure of a .xmi file

Only work with the files i am giving you, store the model in ./models directory
Write up directly the target .xmi file model
```


## Prompt para coversión por IA

```
Generate a .xmi model based on the context of the .md file, the generated model must be based on the .ecore metamodel and the model instance .xmi example

context: @trasformation/contextprompts/LibraryLoanPrompt.md 
metamodel: @models/smm.ecore 
example: @models/smm-example.xmi 

The expected file must have the name: LibraryLoanSystem-smm-pure.xmi
Directly write up the model into the .xmi file in the ./models directory
Only use the files given in the prompt
```
