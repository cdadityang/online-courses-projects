#!/usr/bin/python
# Copyright 2010 Google Inc.
# Licensed under the Apache License, Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0

# Google's Python Class
# http://code.google.com/edu/languages/google-python-class/

import sys
import re
import glob

"""Baby Names exercise

Define the extract_names() function below and change main()
to call it.

For writing regex, it's nice to include a copy of the target
text for inspiration.

Here's what the html looks like in the baby.html files:
...
<h3 align="center">Popularity in 1990</h3>
....
<tr align="right"><td>1</td><td>Michael</td><td>Jessica</td>
<tr align="right"><td>2</td><td>Christopher</td><td>Ashley</td>
<tr align="right"><td>3</td><td>Matthew</td><td>Brittany</td>
...

Suggested milestones for incremental development:
 -Extract the year and print it
 -Extract the names and rank numbers and just print them
 -Get the names data into a dict and print it
 -Build the [year, 'name rank', ... ] list and print it
 -Fix main() to use the extract_names list
"""

def extract_names(filename):
  """
  Given a file name for baby.html, returns a list starting with the year string
  followed by the name-rank strings in alphabetical order.
  ['2006', 'Aaliyah 91', Aaron 57', 'Abagail 895', ' ...]
  """
  # +++your code here+++
  f = open(filename, 'r')
  full_read = f.read()
  match = re.findall(r'<tr.*?><td>(\d+)</td><td>(\w+)</td><td>(\w+)</td>', full_read)
  year_match = re.search(r'Popularity\sin\s(\d+)', full_read)
  all_name_list = []
  for t in match:
  	male_name = t[1] + ' ' + t[0]
  	female_name = t[2] + ' ' + t[0]
  	all_name_list.append(male_name)
  	all_name_list.append(female_name)
  final_list = sorted(all_name_list)
  final_list.insert(0, year_match.group(1))
  final_text = '\n'.join(final_list) + '\n'
  return final_text


def main():
  # This command-line parsing code is provided.
  # Make a list of command line arguments, omitting the [0] element
  # which is the script itself.
  args = sys.argv[1:]

  if not args:
    print('usage: [--summaryfile] file [file ...]')
    sys.exit(1)

  # Notice the summary flag and remove it from args if it is present.
  summary = False
  if args[0] == '--summaryfile':
    summary = True
    del args[0]

  # +++your code here+++
  # For each filename, get the names, then either print the text output
  # or write it to a summary file
  # Windows doesn't recognize "baby*.html" wildcard, so we use glob module.
  # it will return all the wildcards matching in a list.
  for e in glob.glob(args[0]):
  	return_text = extract_names(e)
  	if summary:
  		file_builder = open(e + ".html.summary", "w+")
  		file_builder.write(return_text)
  		file_builder.close()
  	else:
  		print(return_text)
  
if __name__ == '__main__':
  main()
