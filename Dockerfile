# Используем базовый образ Maven для компиляции и сборки проекта
FROM maven:latest as builder

# Копируем все файлы текущего каталога в каталог /app внутри контейнера
ADD . /app

# Устанавливаем рабочий каталог на /app
WORKDIR /app

# Запускаем сборку проекта с помощью Maven, пропуская тесты
RUN mvn clean install -DskipTests


# Используем базовый образ OpenJDK для запуска приложения
FROM openjdk:22

# Добавляем метаданные к образу (в данном случае имя ZEA)
LABEL name="ZEA"

# Определяем аргумент для поиска jar-файла в целевой директории
ARG JAR_FILE=/app/target/*.jar

# Копируем собранный jar-файл из предыдущего этапа сборки в текущий образ
COPY --from=builder ${JAR_FILE} /application.jar

# Указываем команду для запуска приложения
ENTRYPOINT ["java", "-jar", "application.jar"]