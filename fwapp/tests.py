from django.test import TestCase
from django.template import Context, Template
from .funcbool import bool_proc

class ReferencingTest(TestCase):
    def test_autolink(self):
        out = Template(
            '{% load referencing %}'
            '{% autolink text as test_out %}'
            '{{ test_out|safe }}'
        ).render(Context({'text': 'Test (http://google.com/) and https://t.ly: http://ipinfo.io, but also https://codeberg.org/poypoyan.'}))
        self.assertEqual(
            out, 'Test (<a class="ref-url" href="http://google.com/">http://google.com/</a>) and <a class="ref-url" href="https://t.ly">https://t.ly</a>: <a class="ref-url" href="http://ipinfo.io">http://ipinfo.io</a>, but also <a class="ref-url" href="https://codeberg.org/poypoyan">https://codeberg.org/poypoyan</a>.'
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


class FuncboolTest(TestCase):
    def filt(self, x, y: set) -> bool:
        return x in y

    def test_empty_conf(self):
        self.assertEqual(bool_proc([1, 2, 3], {}, self.filt), [[0], [1], [2]])

    def test0(self):
        config = {'or': [{3,4}, {3,5}], 'rem': set()}
        self.assertEqual(bool_proc([1, 2, 3], config, self.filt), [[0], [1], [2]])

    def test1(self):
        config = {'or': [{3,4}, {3,5}], 'rem': set()}
        self.assertEqual(bool_proc([1, 2, 3, 4], config, self.filt), [[0], [1], [2, 3]])
    
    def test2(self):
        config = {'or': [{3,4}, {3,5}], 'rem': set()}
        self.assertEqual(bool_proc([1, 4, 3, 2], config, self.filt), [[0], [1, 2], [3]])

    def test3(self):
        config = {'or': [{3,4}, {3,5}], 'rem': set()}
        self.assertEqual(bool_proc([1, 5, 3, 2], config, self.filt), [[0], [1, 2], [3]])
    
    def test4(self):
        config = {'or': [{3,4}, {3,5}], 'rem': set()}
        self.assertEqual(bool_proc([1, 3, 5, 2], config, self.filt), [[0], [1, 2], [3]])
    
    def test5(self):
        config = {'or': [{3,4}, {3,5}], 'rem': {2}}
        self.assertEqual(bool_proc([1, 3, 5, 2], config, self.filt), [[0], [1, 2]])

    def test6(self):
        config = {'or': [{3,4}, {3,5}], 'rem': {3}}
        self.assertEqual(bool_proc([1, 3, 5, 2], config, self.filt), [[0], [2], [3]])