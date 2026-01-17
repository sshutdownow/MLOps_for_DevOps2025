import streamlit as st
import requests
import json
import os

#from dotenv import load_dotenv
#load_dotenv() # .env

MODEL_API_URL = os.environ.get("CLEARML_MODEL_API_URL")
CLEARML_API_ACCESS_KEY = os.environ.get("CLEARML_API_ACCESS_KEY")
CLEARML_API_SECRET_KEY = os.environ.get("CLEARML_API_SECRET_KEY")

def check_config():
    """Проверяет наличие всех необходимых переменных окружения."""
    missing_vars = []
    if not MODEL_API_URL:
        missing_vars.append("CLEARML_MODEL_API_URL")
    if not CLEARML_API_ACCESS_KEY:
        missing_vars.append("CLEARML_API_ACCESS_KEY")
    if not CLEARML_API_SECRET_KEY:
        missing_vars.append("CLEARML_API_SECRET_KEY")
    return missing_vars

st.title("Интерфейс для модели ClearML")
st.set_page_config(page_title="ClearML Interface", layout="centered")

missing_config = check_config()
if missing_config:
    st.error(f"❌ **Критическая ошибка конфигурации.** Отсутствуют переменные окружения: `{', '.join(missing_config)}`. Приложение не может работать.")
    st.stop()

st.success("✅ Конфигурация загружена успешно.")
st.caption(f"Модель: `{MODEL_API_URL}`")

user_data = st.text_area(
    "**Входные данные для модели (текст):**",
    height=150,
    value=''
)

if st.button("Выполнить инференс"):
    if not user_data.strip():
        st.warning("Пожалуйста, введите данные в текстовое поле.")
    else:
        try:
            auth = (CLEARML_API_ACCESS_KEY, CLEARML_API_SECRET_KEY)
            headers = {"Content-Type": "application/json"}
            with st.spinner("Отправка запроса к модели ClearML Serving..."):
                response = requests.post(
                    MODEL_API_URL,
                    json={"text": user_data},
                    auth=auth,
                    headers=headers,
                    timeout=30
                )

            st.subheader("📄 Результат:")
            if response.status_code == 200:
                st.success("Запрос выполнен успешно!")
                try:
                    result_json = response.json()
                    st.json(result_json)
                except json.JSONDecodeError:
                    st.text(response.text)
            else:
                st.error(f"Сервер вернул ошибку: **{response.status_code}**")
                st.text("Детали ответа:")
                st.code(response.text, language=None)

        except json.JSONDecodeError as e:
            st.error(f"Ошибка в формате JSON: {e}")
        except requests.exceptions.Timeout:
            st.error("Превышено время ожидания ответа от сервера модели.")
        except requests.exceptions.RequestException as e:
            st.error(f"Ошибка сети при обращении к серверу модели: {e}")
