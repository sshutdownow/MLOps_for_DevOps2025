# MlOps_for_DevOps2025

https://grafana.com/blog/monitoring-machine-learning-models-in-production-with-grafana-and-clearml/

https://clear.ml/docs/latest/docs/clearml_serving/


Scikit-learn (sklearn) — это бесплатная и открытая библиотека машинного обучения (Machine Learning) для языка программирования Python.

## Ключевые характеристики и возможности:

### Простота и удобство (Usability):

        Единый, последовательный интерфейс для всех моделей. Основные методы у любой модели: .fit() (обучить), .predict() (спрогнозировать), .score() (оценить).

        Отличная документация с множеством примеров.

### Широкий охват алгоритмов:

        Классификация: Логистическая регрессия, метод опорных векторов (SVM), наивный Байес, случайный лес, градиентный бустинг и др.

        Регрессия: Линейная регрессия, гребневая регрессия (Ridge), лассо (Lasso).

        Кластеризация: K-means, DBSCAN, иерархическая кластеризация.

        Понижение размерности: PCA (метод главных компонент), t-SNE.

        Выбор модели: Разбиение данных, кросс-валидация, поиск по сетке гиперпараметров (GridSearchCV).

        Предобработка данных (Preprocessing): Масштабирование, кодирование категориальных признаков, работа с пропусками.

### Надежная база:

        Построена на мощных научных библиотеках Python: NumPy (работа с массивами), SciPy (научные вычисления) и matplotlib (визуализация).

        Имеет активное сообщество и используется как в академических исследованиях, так и в промышленности.

## Для чего он используется (типичный рабочий процесс)?

    Загрузить данные (часто с помощью pandas).

    Разделить данные на обучающую и тестовую выборки (train_test_split).

    Предобработать данные (масштабировать, закодировать) с помощью StandardScaler, OneHotEncoder и т.д.

    Выбрать и обучить модель (например, RandomForestClassifier) на обучающих данных методом .fit().

    Сделать прогноз на тестовых данных методом .predict().

    Оценить качество модели (точность, полнота, F1-мера) с помощью accuracy_score, classification_report и т.д.



## Мониторинг

[ClearML Serving. Also open source, it’s a ClearML module built on top of the popular NVIDIA Triton Inference Server](https://grafana.com/blog/monitoring-machine-learning-models-in-production-with-grafana-and-clearml/)

[grafana dashboard](https://stackoverflow.com/questions/63518460/grafana-import-dashboard-as-part-of-docker-compose)

[setup grafana in docker](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/#install-plugins-in-the-docker-container)

[grafana-model-performance-example](https://clear.ml/docs/latest/docs/clearml_serving/clearml_serving_extra/#grafana-model-performance-example)
