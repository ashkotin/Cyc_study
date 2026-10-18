This project is dedicated to study Cyc logic. First of all microtheories structure and interconnection.

# eng:

# Project Progress

The project is carried out by assigning specific tasks to an AI agent—initially, the "Academia.org Co-Scientist (beta)" (hereinafter referred to as "AcoS"), though this agent may be replaced once the free trial period ends.

## Task 1: Finding Examples of Microtheories

Initially, AcoS could not locate any accessible microtheories. However, after some time, it reported that it had discovered and analyzed a data dump, from which it extracted several microtheories. Notably, AcoS frequently identifies CycL statements as "corrupted" and proposes its own corrections.

## Task 2: Creating a Multilingual Document from the `MathMt.cycl` Microtheory

The objective is to produce a document in which each unit of knowledge—in this case, a specific statement—is translated into the following languages/formats: Russian, English, FOL (First-Order Logic), Isabelle/HOL, Lean4, OWL 2/FS, and Common Logic.

If a CycL statement cannot be translated into a particular language, this is noted in a comment within that language. The resulting file, `MathMt.all`, was generated entirely by AcoS without any manual editing or post-processing.

# FOL

"FOL" refers to a first-order logic language defined by ANTLR4 specifications for a lexical analyzer and parser (see the `fol` directory). The resulting parser, generated for Python, is fully functional. AcoS was provided with these two files as the formal definition of the language.

# rus:

# ход проекта

Проект выполняется через постановку тех или иных задач перед ИИ-агентом. В первую очередь перед Academia.org Co-Scientist (beta) - AcoS далее. Хотя после окончания бесплатного периода он может быть сменён.

## Задача-1. Найти примеры микротеорий

Сначала AcoS не нашёл какие-либо доступные микротеории. Но через некоторое время вернулся с сообщением что он обнаружил и проанализировал некий дамп. Из которого выделил несколько микротеорий. Причём предложения на CycL он часто считает испорченными и предлагает свою правку.

## Задача-2. Взяв микротеорию MathMt.cycl сформировать многоязычний документ

В котором каждая единица знаний, в данном случае это высказывание, переведено на следующие языки: Русский, Английский, fol, Isabelle/HOL, Lean4, OWL 2/FS, Common Logic.

Если на какой-то язык высказывание CycL переведено быть не может, то это отмечается в комментарии на данном языке.
Результат есть файл MathMt.all сформированный исключительно AcoS без какой-либо дополнительной правки.

# fol

fol есть язык первого порядка заданный заданиями для anlr4 для лексического анализатора и парсера (см. папку fol). Эта связка сгенерированная для Питона работоспособна. AcoS были даны эти два файла вместо описания языка.

