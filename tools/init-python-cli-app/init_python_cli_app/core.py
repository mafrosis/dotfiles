import datetime
import os
import shutil

from jinja2 import Template


def process_template(project_name, verbose=False, clear=False):
    # totally delete project folder before starting
    if clear and os.path.exists(project_name):
        shutil.rmtree(project_name)

    # setup directories
    template_dir = os.path.join(os.path.dirname(__file__), 'template')
    output_dir = os.path.join(os.getcwd(), project_name)

    paths = []

    # copy template files onto output dir
    copytree(project_name, template_dir, output_dir, paths, verbose=verbose)

    data = {
        'project_name': project_name,
        'year': datetime.datetime.now().year
    }

    for path in paths:
        if path.endswith('.jinja'):
            with open(path, 'r') as r:
                # write output file
                with open(os.path.splitext(path)[0], 'w') as w:
                    template = Template(r.read())
                    w.write('{}\n'.format(template.render(data)))

            # delete template file
            os.remove(path)

            if verbose:
                print('--> Jinja processed\n    {}'.format(os.path.splitext(path)[0]))


def copytree(project_name, src, dest, paths, verbose=False):
    # replace paths from 'project_name' to the actual project name
    if 'project_name' in dest:
        # convert dashes to underscores in python module directories
        if os.path.isdir(src):
            dest = dest.replace('project_name', project_name.replace('-', '_'))
        else:
            dest = dest.replace('project_name', project_name)

    if os.path.isdir(src):
        if not os.path.isdir(dest):
            if verbose:
                print('--> {}\n    {}'.format(src, dest))
            os.makedirs(dest)

        files = os.listdir(src)

        for f in files:
            copytree(
                project_name,
                os.path.join(src, f),
                os.path.join(dest, f),
                paths,
                verbose=verbose
            )
    else:
        # special case for converting dashes to underscores in project directory name
        if os.path.basename(dest) == project_name:
            dest = os.path.join(
                os.path.dirname(dest), project_name.replace('-', '_')
            )
        if verbose:
            print('--> {}\n    {}'.format(src, dest))
        shutil.copyfile(src, dest)
        paths.append(dest)
