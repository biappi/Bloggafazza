from datetime import date

import os
import errno

class FileLayoutError (Exception) : pass

class Entry:
	def __init__(self, title, slug, date, body):
		self.title = title
		self.slug = slug
		self.date = date
		self.body = body
	
	@classmethod
	def create_from_path(cls, path):
		import os.path
		
		title = slug = the_date = body = None
		filename = os.path.splitext(os.path.basename(path))[0]
		
		try:
			datestring, slug = filename.split('--', 1)
			year, month, day = datestring.split('-')
			year = int(year)
			month = int(month)
			day = int(day)
			the_date = date(year, month, day)
		except ValueError:
			raise FileLayoutError("Filename not correct for entry at path '%s'" %
			                      path)
		
		entry = open(path, 'r').read()
		title, body = entry.split('\n', 1)
		
		return cls(title, slug, the_date, body)
		
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
			except FileLayoutError: pass
		
		return cls(entries)

class Template:
	def __init__(self):
		self.pageFormat = ''
		self.entryFormat = ''
	
	@classmethod
	def create_from_directory(cls, dir):
		t = cls()
		t.pageFormat = open(os.path.join(dir, 'pageFormat'), 'r').read()
		t.entryFormat = open(os.path.join(dir, 'entryFormat'), 'r').read()
		return t
	
	def render_entry(self, entry, substitutions={}):
		substitutions['TITLE'] = entry.title
		substitutions['SLUG'] = entry.slug
		substitutions['BODY'] = entry.body
		substitutions['DATE'] = entry.date
		
		rendered = self.entryFormat
		
		for k in substitutions:
			rendered = rendered.replace('{{%s}}' % k, str(substitutions[k]))
		
		return rendered
	
	def render_page(self, content):
		return self.pageFormat.replace('{{CONTENT}}', content)

class SiteBuilder:
	def __init__(self, output_dir, entries_dir, template):
		self.output_dir = output_dir
		self.entries_dir = entries_dir
		self.template = template
			
	def render_entry(self, entry):
		entry_filename = '%s.html' % entry.slug
		entry_path = os.path.join(self.entries_dir, entry_filename)
		entry_perma = '/%s' % entry_path
		
		extra = {'PERMALINK': entry_perma}
		entry_string = self.template.render_entry(entry, extra)
		page_string = self.template.render_page(entry_string)
		
		entry_path = os.path.join(self.output_dir, entry_path)
		write_to_file_in_dir(page_string, entry_path)
		
		return entry_string
	
	def render_entry_collection(self, collection):
		entries = list(collection.entries)
		entries.reverse()
		rendered = [self.render_entry(entry) for entry in entries]
		index = self.template.render_page('\n'.join(rendered))
		path = os.path.join(self.output_dir, 'index.html')
		write_to_file_in_dir(index, path)

		
def prepare_output_directory(config):
	import shutil
	import sys
	
	dir = config.OutputDirectory
	if dir[-1] == '/': dir = dir[:-1]
	
	if os.path.exists(dir) and config.ForceDeletion == False:
		print "Output directory already exists, you can use --ForceDeletion!"
		sys.exit(-1)
	
	try:
		shutil.rmtree(dir)
	except OSError as e:
		if   e.errno == errno.ENOENT:  pass
		elif e.errno == errno.ENOTDIR: os.remove(dir)
		else: raise
	
	if config.ResourcesDirectory:
		shutil.copytree(config.ResourcesDirectory, dir)
	else:
		os.mkdir(dir)

def write_to_file_in_dir(what, path):
	try:
		open(path, 'w').write(what)
	except IOError as e:
		if e.errno == errno.ENOENT:
			os.makedirs(os.path.dirname(path))
			open(path, 'w').write(what)
		else:
			pass

def parse_cmdline():
	import argparse
	
	parser = argparse.ArgumentParser(description='Static blog baker.')
	parser.add_argument('-f', '--ForceDeletion', action='store_true',
	                    help='Force the deletion of OutputDir')
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
	template = Template.create_from_directory(config.TemplateDirectory)
	entries = EntriesCollection.create_from_directory(config.DataDirectory)
	builder = SiteBuilder(config.OutputDirectory, 'entries', template)
	
	prepare_output_directory(config)
	builder.render_entry_collection(entries)
