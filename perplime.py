import os
import errno

def title_to_filename(title):
	import datetime
	
	slug = title.lower()
	slug = slug.replace(' ', '-')

	today = datetime.date.today()
	comps = (today.year, today.month, today.day, slug)
	return '{:04}-{:02}-{:02}--{}'.format(*comps)
	
def download_file(url, path):
	import urllib2
	the_file = urllib2.urlopen(url)
	write_to_file_in_dir(the_file.read(), path)
	

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
	
	parser = argparse.ArgumentParser(description='mi.perpli.me')
	parser.add_argument('-t', '--title', required=True,
	                    help='The title of the image')
	parser.add_argument('-d', '--description',
	                    default='',
	                    help='Description of the post')
	parser.add_argument('-u', '--url', required=True,
	                    help='The url of the entry')
	parser.add_argument('-i', '--images-directory',
	                    default='resources/images',
	                    help='Where to store the images')
	parser.add_argument('-I', '--images-url',
	                    default='/images',
	                    help='The images directory absolute url')
	parser.add_argument('-e', '--entries-directory',
	                    default='entries',
	                    help='Where to store the entry file')
	
	return parser.parse_args()

def write_entry(title, description, entryfile, imageurl):
	what = '''{}
<img src="{}" alt="{}"><br>
{}'''.format(title, imageurl, title, description)

	write_to_file_in_dir(what, entryfile)

if __name__ == '__main__':
	config = parse_cmdline()
	
	filename = title_to_filename(config.title)
	entry_file = os.path.join(config.entries_directory, filename)
	image_file = os.path.join(config.images_directory, filename)
	image_url  = os.path.join(config.images_url, filename)
	
	download_file(config.url, image_file)
	write_entry(config.title, config.description, entry_file, image_url)
	
	
	
