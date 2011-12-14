from datetime import date

import os

class FileLayoutError (exception.Exception) : pass

class Entry:
	def __init__(self, title, slug, date, body):
		self.title = title
		self.slug = slug
		self.date = date
		self.body = body
	
	@classmethod
	def create_from_path(cls, path):
		import os.path
		
		title, slug, date, body = None
		
		filename = os.path.splitext(os.path.basename(path))[0]
		
		try:
			datestring, self.slug = filename.split('--', 1)
			year, month, day = datestring.split('-')
			year = int(year)
			month = int(month)
			day = int(day)
			date = date(year, month, day)
		except ValueError:
			raise FileLayoutError("Filename not correct for entry at path '%s'" %
			                      path)
		
		entry = open(path, 'r').read()
		title, body = entry.split('\n', 1)
		
		return cls(title, slug, date, body)
		
class EntriesCollection:
	def __init__(self, entries=[]):
		self.entries = entries
	
	@classmethod
	def create_from_directory(cls, dir):
		entries = []
		for filename in os.listdir(dir):
			if filename.startswith('.'):
				pass
			
			path = os.path.join(dir, filename)
			
			try: entries.append(Entry.create_from_path(path))
			except: pass
		
		return cls(entries)

def prepare_output_directory(config):
	import shutil
	import errno

	try:
		shutil.rmtree(config.OutputDirectory)
	except OSError as e:
		if e.errno == errno.ENOENT: pass
		else: raise
	
	if config.ResourcesDirectory:
		shutil.copytree(config.ResourcesDirectory, config.OutputDirectory)
	else:
		os.mkdir(config.OutputDirectory)

def parse_cmdline():
	import argparse
	
	parser = argparse.ArgumentParser(description='Static blog baker.')
	parser.add_argument('-d', '--DataDirectory', required=True,
	                    help='The directory with the entries')
	parser.add_argument('-t', '--TemplateDirectory', required=True,
	                    help='The directory with the template')
	parser.add_argument('-o', '--OutputDirectory', required=True,
	                    help='The directory in which to store the output')
	parser.add_argument('-r', '--ResourcesDirectory', default=None,
	                    help='A directory to with static resources to copy')
	
	return parser.parse_args()

if __name__ == '__main__':
	config = parse_cmdline()
	prepare_output_directory(config)