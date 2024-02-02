## Ansible token replacement
Using VS Code, you can replace token that are not supported by Ansible / jinja2
Indeed, files inside the templates folder cannot contains `{{` and `}}`

Search on the file : 
(\{\{|\}\})

And replace by :
{{ '$1' }}
