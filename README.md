# Todoist

<img width="1348" height="575" alt="Screenshot 2025-07-27 at 17 27 24" src="https://github.com/user-attachments/assets/a9cbdcb0-0537-4c55-8877-b2648ebe12bc" />


[![Swift](https://img.shields.io/badge/swift-5.5%2B-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-15.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Xcode](https://img.shields.io/badge/Xcode-14.0%2B-lightgrey.svg)](https://developer.apple.com/xcode/)
[![XcodeGen](https://img.shields.io/badge/XcodeGen-support-green.svg)](https://github.com/yonaskolb/XcodeGen)
[![SwiftLint](https://img.shields.io/badge/SwiftLint-enabled-success.svg)](https://github.com/realm/SwiftLint)

> **Todoist** — приложение для управления списком дел (todo-list), построенное на Swift. Проект активно развивается: внедряются новые функции, совершенствуется интерфейс, расширяются возможности.

---

## Краткое описание

**Todoist** — современный шаблон для ведения и управления задачами на iOS, с акцентом на масштабируемую архитектуру и современные best practices. В планах — интеграция авторизации через **Firebase** с применением архитектурного паттерна **Coordinator** и система визуальных бейджей (badges) для мотивации пользователей.

---

## Особенности

- Чистый код на Swift (100%)
- Генерация Xcode-проекта через **XcodeGen**
- Проверка стиля — **SwiftLint**
- Гибкая и чистая структура, легкая масштабируемость
- Гибкая и модульная архитектура
- Кастомные пользовательские интерфейсы (UI-компоненты)
- Загрузка данных и картинок из сети с поддержкой пагинации
- Загрузка изображений с устройства пользователя
- Выбор даты и времени с помощью UIDatePicker
- Использование **debouncer** для обработки частых событий (напр., поиска или загрузки)
- Встроенный логгер для отслеживания событий и ошибок
- *Планируется*: авторизация через Firebase + Coordinator-подход

---

## Требования
- **Минимальная iOS**: 15.0
---

## Быстрый старт

#### 1. Клонируйте репозиторий

```
git clone https://github.com/artkriukov/Todoist.git
cd Todoist
```


#### 2. Установите зависимости

- **XcodeGen**:
    ```
    brew install xcodegen
    ```
- **SwiftLint**:
    ```
    brew install swiftlint
    ```

#### 3. Сгенерируйте Xcode-проект

```
xcodegen
```


#### 4. Откройте и соберите проект

```
open Todoist.xcodeproj
```


Далее работайте как обычно: выберите симулятор/устройство, проведите сборку и тестирование.

---

## Структура и конфигурация

- `project.yml` — настройки XcodeGen: изменяйте для настройки модулей, таргетов и т.д.
- `.swiftlint.yml` — правила проверки кода (SwiftLint)
- `.gitignore` — стандартные исключения для iOS/Swift

---

## Стиль кода и линтинг

Для поддержания чистоты и читаемости кода используется SwiftLint:
```
swiftlint
```


- SwiftLint использует конфиг из корня проекта.
- Легко интегрируется в CI/CD или автоматизацию сборки.

---

## Дорожная карта (Roadmap) / В разработке

:construction: Проект находится в активной фазе!  
Планируются ключевые обновления:
- Авторизация пользователей через **Firebase** (Coordinator)
- Присваивание бейджей задачам и пользователям
- Продвинутая система уведомлений
- Расширенные фильтры и категории

---

> **Примечание:** Некоторые ключевые функции (авторизация Firebase, Coordinator) пока в процессе реализации. Следите за обновлениями!
