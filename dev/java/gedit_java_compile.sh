#!/bin/sh
#Java compilation
cd $GEDIT_CURRENT_DOCUMENT_DIR
python -c "
import os

arg = '$GEDIT_CURRENT_DOCUMENT_DIR/$GEDIT_CURRENT_DOCUMENT_NAME'
package = ''
data = open(arg, 'r').readlines()

for i in range(len(data)):
	temp = data[i].strip()
	if temp[0:7] == 'package':
		package = temp[8:len(temp)-1]

if package != '':
	for i in range(package.count('.') + 2):
		arg = arg[0:arg.rfind('/')]
	
	os.system('javac -cp ' + arg + ' ' + '$GEDIT_CURRENT_DOCUMENT_DIR/$GEDIT_CURRENT_DOCUMENT_NAME')
	os.system('java -classpath ' + arg + ' ' + package + '.' + '${GEDIT_CURRENT_DOCUMENT_NAME%.java}')
else:
	os.system('javac $GEDIT_CURRENT_DOCUMENT_NAME')
	os.system('java ${GEDIT_CURRENT_DOCUMENT_NAME%.java}')
"
