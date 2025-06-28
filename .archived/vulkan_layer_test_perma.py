# file: test_vulkan_layers.py

from llama_cpp import Llama
import subprocess
import re
import psutil
import os
import sys


def detect_vram_mb():
    try:
        out = subprocess.check_output(["vulkaninfo"], stderr=subprocess.DEVNULL).decode()
        match = re.search(r"deviceLocal\s*=\s*(\d+)", out)
        if match:
            return int(match.group(1)) // (1024 * 1024)
    except:
        return None


def confirm_vulkan_loaded():
    p = psutil.Process()
    return [dll.path for dll in p.memory_maps() if "vulkan" in dll.path.lower()]


def ensure_vulkan_enabled():
    if "GGML_VULKAN=1" not in os.environ.get("LLAMA_CPP_BACKEND", ""):
        os.environ["LLAMA_CPP_BACKEND"] = "GGML_VULKAN=1"
        print("\n[INFO] Vulkan backend enforced via environment variable\n")


# Ensure Vulkan usage is enforced via env var
ensure_vulkan_enabled()

vram_mb = detect_vram_mb() or 4096
layer_size_mb = 400
max_layers = max(1, vram_mb // layer_size_mb)

print(f"Detected usable VRAM: {vram_mb} MB")
print(f"Loading {max_layers} GPU layers into Vulkan backend")

llm = Llama(
    model_path=r"C:\Users\comfy\llama.cpp\models\Qwen3-8B-128K-GGUF\Qwen3-8B-128K-UD-Q4_K_XL.gguf",
    n_gpu_layers=max_layers,
    verbose=True
)

output = llm("What is the meaning of life?", max_tokens=10)
print("\nModel output:", output)

print("\nVulkan DLLs loaded:")
print(confirm_vulkan_loaded())
