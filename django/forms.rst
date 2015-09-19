Forms
=====

* https://docs.djangoproject.com/en/dev/topics/forms/
* https://docs.djangoproject.com/en/dev/ref/forms/api/

A basic form::

    from django import forms

    class ContactForm(forms.Form):
        subject = forms.CharField(max_length=100)


Processing a form in a view function::

    def contact(request):
        if request.method == 'POST': # If the form has been submitted...
            form = ContactForm(request.POST) # A form bound to the POST data
            if form.is_valid(): # All validation rules pass
                # Process the data in form.cleaned_data
                # ...
                return HttpResponseRedirect('/thanks/') # Redirect after POST
        else:
            form = ContactForm() # An unbound form

        return render_to_response('contact.html', {
            'form': form,
        })

https://docs.djangoproject.com/en/dev/topics/forms/modelforms/

A model form::

    from django.forms import ModelForm, ValidationError

    # Create the form class.
    class ArticleForm(ModelForm):
        class Meta:
            model = Article
            fields = ('name', 'title')
            # or
            exclude = ('birth_date')

        def clean_fieldname(self):
            if 'fieldname' in self.cleaned_data:
                data = self.cleaned_data['fieldname']
                if not /valid/:
                    raise ValidationError("msg")
                return data

        def clean(self):
            data = self.cleaned_data
            if not /valid/:
                raise ValidationError("msg")
            return data

    # Creating a form to add an article.
    form = ArticleForm()
    ...
    new_article = form.save()

    # Creating a form to change an existing article.
    article = Article.objects.get(pk=1)
    form = ArticleForm(instance=article)
    ...
    form.save()

    # Create a form to edit an existing Article, but use POST data to populate the form.
    a = Article.objects.get(pk=1)
    f = ArticleForm(request.POST, instance=a)
    f.save()


Render form in template::

    <!-- Using table - avoid that part - but this does show how to render the fields individually -->
          <form {% if form.is_multipart %}enctype="multipart/form-data"{% endif %} action="" method="post" class="uniForm">{% csrf_token %}
            <table>
              <fieldset>
                {% if form.non_field_errors %}
                  <tr><td colspan="2">{{ form.non_field_errors }}</td></tr>
                {% endif %}
                {% for field in form %}
                  <tr{% if field.field.required %} class="required"{% endif %}>
                    <th style="text-align: left"><label for="{{ field.id_for_label }}">{{ field.label }}:</label></th>
                    <td>{% if field.errors %}
                          {{ field.errors }}<br/>
                        {% endif %}
                        {{ field }}
                        or even <input id="{{ field.id_for_label }}" name="{{ field.html_name }}" value="{{ field.value }}"
                        {% if field.help_text %}
                          <br/><span class="helptext">{{ field.help_text }}</span>
                        {% endif %}
                    </td>
                  </tr>
                {% endfor %}
              </fieldset>
            </table>
            <div class="ctrlHolder buttonHolder">
              <button type="submit" class="primaryAction" name="submit_changes">Submit changes</button>
            </div>
          </form>

    <!-- Using a list, which is preferred -->

        <form {% if form.is_multipart %}enctype="multipart/form-data"{% endif %} action="" method="post" class="uniForm">{% csrf_token %}
            <fieldset>
                <ul>
                    {{ form.as_ul }}
                    <li>
                        <div class="ctrlHolder buttonHolder">
                            <button type="submit" class="primaryAction" name="submit_changes">Submit changes</button>
                        </div>
                    </li>
                </ul>
            </fieldset>
        </form>


Read-only form
==============

Call this on the form::

    def make_form_readonly(form):
        """
        Set some attributes on a form's fields that, IN COMBINATION WITH TEMPLATE CHANGES,
        allow us to display it as read-only.
        """

        # Note that a new BoundField is constructed on the fly when you access
        # form[name], so any data we want to persist long enough for the template
        # to access needs to be on the "real" field.  We just use the BoundField
        # to get at the field value.

        for name in form.fields:
            field = form.fields[name]
            bound_field = form[name]
            if hasattr(field.widget, 'choices'):
                try:
                    display_value = dict(field.widget.choices)[bound_field.value()]
                except KeyError:
                    display_value = ''
            else:
                display_value = bound_field.value()

            field.readonly = True
            field.display_value = display_value

Do things like this in the templates::

    {# Date field #}
    {% if field.field.readonly %}
        <span class="form-control">{{ field.value|date:'c' }}</span>
    {% else %}
        <input type="date" class="form-control" id="{{ field.id_for_label }}" name="{{ field.html_name }}" value="{{ field.value|date:'c' }}">
    {% endif %}

    {# input fields #}
    {% if field.field.readonly %}
        <span class="form-control">{{ field.value }}</span>
    {% else %}
        <input type="{% block input_field_type %}text{% endblock %}" class="form-control" id="{{ field.id_for_label }}" name="{{ field.html_name }}" value="{{ field.value }}" {% if field.field.widget.attrs.placeholder %}placeholder="{{ field.field.widget.attrs.placeholder }}"{% endif %} {% block input_attrs %}{% endblock %}>
    {% endif %}

    {# select fields #}
    {% if field.field.readonly %}
        <span class="form-control">{{ field.field.display_value }}</span>
    {% else %}
        <select class="form-control" id="{{ field.id_for_label }}"  name="{{ field.html_name }}" placeholder="">
          {% for val, label in field.field.widget.choices %}
            <option value="{{ val }}"{% if field.value|stringformat:'s' == val|stringformat:'s' %} selected{% endif %}>{{ label }}</option>
          {% endfor %}
        </select>
    {% endif %}
