# file: osmosis_structured_demo.py

import subprocess
import json
import jsonschema
import re
import time
import gradio as gr

# Global store for debug info
debug_attempts = []

def run_llamacpp(prompt, model_path, system_prompt=None):
    command = [
        "llama-cli",  # or path to ./main from llama.cpp
        "--model", model_path,
        "--temp", "0",
        "--top-p", "1.0",
        "--n-predict", "256",
        "--prompt", prompt,
    ]
    if system_prompt:
        command.extend(["--system", system_prompt])
    if "-instruct" in model_path.lower():
        command.append("--instruct")

    result = subprocess.run(command, capture_output=True, text=True)
    stdout = result.stdout.strip()
    stderr = result.stderr.strip()
    if not stdout:
        print(f"[LLM Error] stderr: {stderr}")
    return stdout or stderr

def extract_json_from_text(text):
    try:
        match = re.search(r'\{.*\}', text, re.DOTALL)
        return json.loads(match.group(0)) if match else {}, match.group(0) if match else ""
    except json.JSONDecodeError:
        return {}, ""

def validate_json(instance, schema):
    try:
        jsonschema.validate(instance=instance, schema=schema)
        return True, ""
    except jsonschema.ValidationError as e:
        return False, str(e)

def retry_until_valid(prompt, schema, model_path, system_prompt=None, max_retries=3):
    global debug_attempts
    debug_attempts.clear()

    for attempt in range(max_retries):
        raw = run_llamacpp(prompt, model_path, system_prompt)
        parsed, raw_json = extract_json_from_text(raw)
        valid, error = validate_json(parsed, schema)
        debug_attempts.append({
            "attempt": attempt + 1,
            "valid": valid,
            "error": error,
            "raw_json": raw_json,
            "full_output": raw
        })
        if valid:
            return parsed, raw
        time.sleep(1)
    raise RuntimeError("Failed to get valid structured output after multiple attempts.")

# Schema definition
function_schema = {
    "type": "object",
    "properties": {
        "problem": {"type": "string"},
        "answer": {"type": "string"}
    },
    "required": ["problem", "answer"]
}

def interactive_test(prompt, model_file):
    few_shot = """You are a math solver AI. Only respond with JSON in the following format:
{
  "problem": "<original problem>",
  "answer": "<final boxed answer>"
}
"""
    prompt = few_shot + "\n" + prompt.strip()
    try:
        structured, raw = retry_until_valid(prompt=prompt, schema=function_schema, model_path=model_file)
        return f"Structured Output:\n{json.dumps(structured, indent=2)}\n\nRaw LLM Output:\n{raw}"
    except Exception as e:
        return f"Error: {str(e)}"

def show_debug():
    if not debug_attempts:
        return "No debug attempts recorded."
    return json.dumps(debug_attempts, indent=2)

if __name__ == "__main__":
    with gr.Blocks() as demo:
        gr.Markdown("## Osmosis-Style Structured Output Tester")
        model_file = gr.Textbox(label="Model Path", value="models/Qwen3-8B-128K-GGUF/Qwen3-8B-128K-UD-Q4_K_XL.gguf")
        prompt = gr.Textbox(label="Prompt", value="What is (3^2 + 4^2)?", lines=4)
        output = gr.Textbox(label="Parsed Structured Output & Raw LLM Response", lines=16)
        debug_output = gr.Textbox(label="Debug Info", lines=16)
        with gr.Row():
            run_button = gr.Button("Run")
            debug_button = gr.Button("Show Debug")

        run_button.click(interactive_test, inputs=[prompt, model_file], outputs=output)
        debug_button.click(show_debug, outputs=debug_output)

    demo.launch()
