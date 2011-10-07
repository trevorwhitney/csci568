#!/bin/sh
CP="$CLASSPATH:/home/trevor/:/opt/java/classpath/sqlitejdbc-v056.jar:/opt/weka/weka-3-6-5/weka.jar"
java -cp $CP -Xmx500m weka.core.converters.CSVLoader names.csv > names2.arff
java -cp $CP -Xmx500m weka.gui.explorer.Explorer
