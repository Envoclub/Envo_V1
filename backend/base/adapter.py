from allauth.account.adapter import DefaultAccountAdapter
from django.contrib.sites.shortcuts import get_current_site
from django.template.loader import render_to_string
from django.template import TemplateDoesNotExist
from django.core.mail import EmailMessage

class CustomAccountAdapter(DefaultAccountAdapter):
    def get_email_confirmation_redirect_url(self, request):
        # Return the desired redirect URL after email confirmation
        return 'https://play.google.com/store/apps/details?id=com.benignapp'
    
    def is_open_for_signup(self, request):
        if request.user and request.user.is_superuser:
            return True
        return super().is_open_for_signup(request)

    def render_mail(self, template_prefix, email, context, headers=None):
        to = [email] if isinstance(email, str) else email
        subject = render_to_string("{0}_subject.txt".format(template_prefix), context)
        # remove superfluous line breaks
        subject = " ".join(subject.splitlines()).strip()
        subject = self.format_email_subject(subject)

        from_email = self.get_from_email()

        bodies = {}
        for ext in ["html", "txt"]:
            try:
                template_name = "{0}_message.{1}".format(template_prefix, ext)
                bodies[ext] = render_to_string(
                    template_name,
                    context,
                    self.request,
                ).strip()
            except TemplateDoesNotExist:
                pass

        if "html" in bodies:
            msg = EmailMessage(subject, bodies["html"], from_email, to, headers=headers)
            msg.content_subtype = "html"  # Main content is now text/html
        else:
            # Treat the text content as HTML by wrapping it in <p> tags
            text_content = "<p>{0}</p>".format(bodies["txt"])
            msg = EmailMessage(subject, text_content, from_email, to, headers=headers)
            msg.content_subtype = "html"  # Main content is now text/html

        return msg
