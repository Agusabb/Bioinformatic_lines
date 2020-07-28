import os
cwd = os.getcwd()

with open("files_names.txt", "w") as a:
    for path, subdirs, files in os.walk(cwd):
       for filename in files:
         f = os.path.join(path, filename)
         a.write(str(f) + os.linesep)