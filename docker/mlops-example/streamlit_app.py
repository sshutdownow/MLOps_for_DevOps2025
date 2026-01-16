import streamlit as st

st.title("Анализ тональности текста")
user_input = st.text_area("Введите текст для анализа:")

if st.button("Анализировать"):
    result = classifier(user_input)
    label = result[0]['label']
    score = result[0]['score']
    st.write(f"Результат: {label} (уверенность: {score:.2f})")
    task.get_logger().report_text(f"Input: {user_input} | Result: {label}")
