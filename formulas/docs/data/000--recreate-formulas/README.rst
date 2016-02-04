

000000--recreate-formulas
==========================
* ``./formulas_transforms.usrlog.log`` -- usrlog.log file --
  https://westurner.org/dotfiles/usrlog
  (``~/-dotfiles/scripts/usrlog.sh`` + ``bash`` -> ``${VIRTUAL_ENV}/-usrlog.log``, ``scripts/usrlog.py``) --
* ``git grep`` find previous incantations of ``term`` TODO
* ``git show rev:.gitmodules``
* ``grep``, ``sed``, ``sort``, and ``pyline`` urls from log (``formulas.urls``)
*  manually comment duplicates from previous with ``vim``
* ``git clone`` each url (``el -v --each``)
* update ``.gitmodules`` **through git** w/ ``el -v --each`` and
  ``~/-dotfiles/scripts/git-subrepo2submodule.sh``: 
  https://github.com/westurner/dotfiles/blob/develop/scripts/git-subrepo2submodule.sh
