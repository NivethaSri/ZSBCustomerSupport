def should_escalate(user_message, ai_response):
    escalation_keywords = [
        "not working",
        "didn't help",
        "connect support",
        "human",
        "agent",
        "still issue"
    ]

    text = user_message.lower()

    for word in escalation_keywords:
        if word in text:
            return True

    return False