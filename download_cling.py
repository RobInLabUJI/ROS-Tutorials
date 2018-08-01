from HTMLParser import HTMLParser
from urllib2 import urlopen
from urllib import urlretrieve
from subprocess import call
import sys

clingDownloadPage = "https://root.cern.ch/download/cling/"

clingLink = ""
class PageParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        global clingLink
        
        attrsDict = dict(attrs)
        
        if tag == "a" and "href" in attrsDict:
            href = attrsDict['href']
            
            if href.startswith("cling") and "ubuntu16" in href and href > clingLink:
                clingLink = href
        
parser = PageParser()
f = urlopen(clingDownloadPage)
parser.feed(f.read().decode('utf-8'))

if not clingLink.startswith("/"):
    clingLink = clingDownloadPage + clingLink

filename = clingLink.split("/")[-1]

def run(command):
    call(command.split(" "))

run('echo Getting Cling from ' + clingLink)
urlretrieve (clingLink, filename)
run("echo Done")
run("tar -xvf " + filename + " --strip 1 -C /cling")
run("rm -f " + filename)