============
Contributing
============


.. include:: goals.rst

Ways to Contribute
=====================
This is a small project.

Contributions are welcome, and they are greatly appreciated! Every
little bit helps.

You can contribute in many ways:

* :ref:`Report bugs <bug>`
* :ref:`Add project tags <project-tags>`
* :ref:`Fix bugs <bug>`
* :ref:`Suggest features <feat>`
* :ref:`Implement features <feat>`
* :ref:`Write documentation <doc>`
* `Submit feedback`_
* :ref:`Send a patch or pull request <pull-request-guidelines>`


.. _project-tags:

Project Tags
==============
Use these uppercase tags in issues and commit messages
to help organize commits:

::

    ENH: Enhancement / Feature
    BUG: Bug
    DOC: Documentation
    TST: Test
    BLD: Build
    PRF: Performance
    CLN: Cleanup
    SEC: Security


Commit Messages::

    ENH: Add new feature (closes #3)
    FIX: Fixes #3


Separate multiple tags with a comma::

    DOC,BLD,TST: Improve build docs and tests
    TST,BUG: Add a test for reproducing a bug



.. _enh:

ENH: Enhancement
==================

Look through the GitHub issues for features. Anything tagged with "ENH"
is open to whoever wants to implement it.

If you are proposing a feature (ENH):

* Explain in detail how it would work.
* Keep the scope as narrow as possible, to make it easier to implement.
* Remember that this is a volunteer-driven project, and that contributions
  are welcome :)


.. _doc:

DOC: Documentation
====================
Write Documentation

provis could always use more documentation (DOC), whether as part of the 
official provis docs, in docstrings, or even on the web in blog posts,
articles, and such.


.. _bug:

BUG: Bug
==========

.. _report-bugs:

Report Bugs
-------------
Report bugs at https://github.com/westurner/provis/issues.

If you are reporting a bug, please include:

* Your operating system name and version.
* Any details about your local setup that might be helpful in troubleshooting.
* Detailed steps to reproduce the bug.


.. _fix-bugs:

Fix Bugs
----------
Look through the GitHub issues for bugs. Anything tagged with "BUG"
is open to whoever wants to implement it.

.. _tst:

TST: Test
===========

.. _bld:

BLD: Build
============

.. _prf:

PRF: Performance
===================

.. _cln:

CLN: Cleanup
==============

.. _sec:

SEC: Security
===============


Contributing References
-------------------------

* feat, fix, docs, style, refactor, perf, test, chore 
  -- `AngularJS CONTRIBUTING.md
  <https://github.com/angular/angular.js/blob/master/CONTRIBUTING.md#type>`_
* ENH, BUG, DOC, TST, BLD, PERF, CLN
  -- `Pandas CONTRIBUTING.md
  <https://github.com/pydata/pandas/blob/master/CONTRIBUTING.md>`_
* ``{{ cookiecutter.repo_name }}``
  -- `Cookiecutter-pypackage CONTRIBUTING.rst
  <https://github.com/audreyr/cookiecutter-pypackage/blob/master/%7B%7Bcookiecutter.repo_name%7D%7D/CONTRIBUTING.rst>`_


.. _submit-feedback:

Submit Feedback
=================
The best way to send feedback is to file an issue at
https://github.com/westurner/provis/issues.


.. _get_started:

Get Started!
==============

Ready to contribute? Here's how to set up `provis` for local development.

1. Fork the `provis` repo on GitHub.
2. Clone your fork locally::

    $ git clone ssh://git@github.com/your_name_here/provis.git

3. Install your local copy into a virtualenv.
   Assuming you have virtualenvwrapper installed,
   this is how you set up your fork for local development::

    $ mkvirtualenv provis
    $ cd provis/
    $ python setup.py develop

4. Create a branch for local development::

    $ git checkout -b name-of-your-bugfix-or-feature
   
   Now you can make your changes locally.

5. When you're done making changes, check that your changes pass flake8 and the tests, including testing other Python versions with tox::

    $ flake8 provis tests
    $ python setup.py test
    $ tox

   To get flake8 and tox, just pip install them into your virtualenv. 

6. Commit your changes and push your branch to GitHub::

    $ git add .
    $ git commit -m "Your detailed description of your changes."
    $ git push origin name-of-your-bugfix-or-feature

7. Submit a pull request through the GitHub website.


.. _pull-request-guidelines:

Pull Request Guidelines
=========================

Before you submit a pull request, check that it meets these guidelines:

1. The pull request should include tests (TST).
2. The pull request could have `Project Tags`_.
3. If the pull request adds functionality, the docs should be updated. Put
   your new functionality into a function with a docstring, and add the
   feature to the list in README.rst.
4. The pull request should work for Python 2.6, 2.7, and 3.3, and for PyPy. Check 
   https://travis-ci.org/westurner/provis/pull_requests
   and make sure that the tests pass for all supported Python versions.

Tips
=====

To run a subset of tests::

	$ python -m unittest tests.test_provis
