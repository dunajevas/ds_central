import requests
import re
import json
from bs4 import BeautifulSoup

BASE_URL = "http://www.datasciencecentral.com/profiles/blog/"
#number of pages
PAGES = 52

def scrape_blog_posts():
    """ get post urls and scrape them """

    results = []

    pages = range(1, PAGES)
    for page in pages:
        response = requests.get(BASE_URL + "list?page=" + str(page))

        # parse HTML using Beautiful Soup
        # this returns a `soup` object which
        # gives us convenience methods for parsing html

        soup = BeautifulSoup(response.content)

        # find all the posts in the page.

        posts = soup.find_all('h3', {'class':'title'})



        for post in posts:

            #get url of post

            url = post.find_all('a')[1]['href']

            results.append(scrape_info(url))

    with open("out.json", 'wb') as outfile:
        json.dump(results, outfile)



def find_words(s):
    return re.findall(re.compile('\w+'), s)

def count_results_set(obj):
    count = 0
    for o in obj:
        count += 1
    return count

def scrape_info(url):
    """ Extract information from a missed connections's page. """

    # retrieve the missed connection with requests
    response = requests.get(url)

    soup = BeautifulSoup(response.content)

    data = {
        'source_url': url,
        'title': soup.find('title').text,
        'posted': soup.find_all('a', {'class':'nolink'})[1].text,
        'tags': find_words(soup.find_all('p', {'class':'small object-detail'})[0].text)[1:],
        'views': soup.find('span', {'class':'view-count'}).text,
        'hrefs': count_results_set(soup.body.find_all('a', href=True)),
        'imglink': soup.find('img', {'class':'photo photo'})['src'],
        'images': count_results_set(soup.body.find_all('img'))
    }

    return data


if __name__ == '__main__':
    scrape_blog_posts()
