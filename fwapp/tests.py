from django.test import SimpleTestCase
from django.template import Context, Template

# Create your tests here.

class AutoLinkTest(SimpleTestCase):
    def test_autolink(self):
        "The flatpage template tag retrieves all flatpages for an authenticated user"
        out = Template(
            "{% load autolink %}"
            "{% autolink text as test_out %}"
            "{{ test_out|safe }}"
        ).render(Context({'text': 'Test (http://google.com/) and https://t.ly: http://ipinfo.io, but also https://codeberg.org/poypoyan.'}))
        self.assertEqual(
            out, 'Test (<a href="http://google.com/">http://google.com/</a>) and <a href="https://t.ly">https://t.ly</a>: <a href="http://ipinfo.io">http://ipinfo.io</a>, but also <a href="https://codeberg.org/poypoyan">https://codeberg.org/poypoyan</a>.'
        )