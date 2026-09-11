# R8 rules for the release build.

# google_mlkit_text_recognition references every script recognizer from
# TextRecognizer.initialize(), but we only bundle the Latin model (the MRZ
# scanner reads Latin passports). Suppress the missing-class warnings for the
# script packages we deliberately leave out.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
