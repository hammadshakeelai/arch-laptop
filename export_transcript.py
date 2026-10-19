import json
import os
import re

jsonl_path = r"C:\Users\HP\.gemini\antigravity\brain\8985db24-12f2-4ed0-9104-89fcac84b84e\.system_generated\logs\transcript_full.jsonl"
output_md = r"c:\Users\HP\Documents\GitHub\arch-laptop\FULL_CHAT_LOG.md"

def clean_user_text(text):
    if not text:
        return ""
    # Extract content between <USER_REQUEST> and </USER_REQUEST> if present
    match = re.search(r"<USER_REQUEST>(.*?)</USER_REQUEST>", text, re.DOTALL)
    if match:
        content = match.group(1).strip()
    else:
        content = text.strip()
    # Remove metadata tags
    content = re.sub(r"<ADDITIONAL_METADATA>.*?</ADDITIONAL_METADATA>", "", content, flags=re.DOTALL)
    content = re.sub(r"<USER_SETTINGS_CHANGE>.*?</USER_SETTINGS_CHANGE>", "", content, flags=re.DOTALL)
    return content.strip()

with open(jsonl_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

chat_entries = []

for line in lines:
    if not line.strip():
        continue
    try:
        data = json.loads(line)
    except Exception:
        continue

    step_index = data.get("step_index", 0)
    source = data.get("source", "")
    step_type = data.get("type", "")
    created_at = data.get("created_at", "")
    content = data.get("content", "")

    if step_type == "USER_INPUT":
        user_msg = clean_user_text(content)
        if user_msg:
            chat_entries.append({
                "role": "User",
                "time": created_at,
                "step": step_index,
                "text": user_msg
            })
    elif step_type == "PLANNER_RESPONSE":
        # Check if there is visible assistant content
        if content and content.strip():
            chat_entries.append({
                "role": "Antigravity (AI)",
                "time": created_at,
                "step": step_index,
                "text": content.strip()
            })
        elif data.get("tool_calls"):
            # Include notable tool actions summary
            calls = data.get("tool_calls", [])
            summaries = []
            for c in calls:
                s = c.get("args", {}).get("toolSummary", "")
                if s:
                    summaries.append(s.strip('"'))
            if summaries:
                chat_entries.append({
                    "role": "Tool Execution",
                    "time": created_at,
                    "step": step_index,
                    "text": f"Executed: {', '.join(summaries)}"
                })

# Write out markdown
with open(output_md, "w", encoding="utf-8") as f:
    f.write("# Arch Linux Migration & Setup — Complete Conversation Log\n\n")
    f.write("> **Source:** Antigravity AI Pair Programming Session\n")
    f.write("> **Target Machine:** MECHREVO Code 01 / R14P (AMD Ryzen 5 7430U, 8GB RAM, Arch Linux Btrfs)\n")
    f.write(f"> **Total Steps Recorded:** {len(chat_entries)}\n\n")
    f.write("---\n\n")

    for entry in chat_entries:
        role = entry["role"]
        time_str = entry["time"]
        step = entry["step"]
        text = entry["text"]

        if role == "User":
            f.write(f"### 👤 User (Step {step} • {time_str})\n\n")
            f.write(f"{text}\n\n")
            f.write("---\n\n")
        elif role == "Antigravity (AI)":
            f.write(f"### 🤖 Antigravity Assistant (Step {step} • {time_str})\n\n")
            f.write(f"{text}\n\n")
            f.write("---\n\n")
        elif role == "Tool Execution":
            f.write(f"> ⚙️ *{text}*\n\n")

print(f"Generated {output_md} successfully with {len(chat_entries)} entries.")
