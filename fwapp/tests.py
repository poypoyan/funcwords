from django.test import SimpleTestCase
from django.template import Context, Template


class ReferencingTest(SimpleTestCase):
    def test_autolink(self):
        out = Template(
            '{% load referencing %}'
            '{% autolink text as test_out %}'
            '{{ test_out|safe }}'
        ).render(Context({'text': 'Test (http://google.com/) and https://t.ly: http://ipinfo.io, but also https://codeberg.org/poypoyan.'}))
        self.assertEqual(
            out, 'Test (<a href="http://google.com/">http://google.com/</a>) and <a href="https://t.ly">https://t.ly</a>: <a href="http://ipinfo.io">http://ipinfo.io</a>, but also <a href="https://codeberg.org/poypoyan">https://codeberg.org/poypoyan</a>.'
        )

    def test_citelink(self):
        out = Template(
            '{% load referencing %}'
            '{% citelink text refs as test_out %}'
            '{{ test_out|safe }}'
        ).render(Context({
            'text': 'This is from [poy2025, p. 3], but another source [dog2021] disagrees.',
            'refs': [{'name': 'dog2021'}, {'name': 'poy2025'}]
        }))
        self.assertEqual(
            out, 'This is from [<a href="#ref-2">2</a>, p. 3], but another source [<a href="#ref-1">1</a>] disagrees.'
        )