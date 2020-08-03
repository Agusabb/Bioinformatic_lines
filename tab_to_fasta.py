from Bio import SeqIO
import sys

records = SeqIO.parse(sys.argv[1], "tab")
count = SeqIO.write(records, sys.argv[2], "fasta")
print("Listo idolo, se convirtieron %i entradas" % count)