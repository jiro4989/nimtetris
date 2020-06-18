====
nimtetris
====

|nimble-version| |nimble-install| |gh-actions|

A terminal tetris in Nim.

Linux demo:

|demo-linux|

Windows demo:

|demo-win|

.. contents:: Table of contents

Usage
=====

.. code-block:: shell

   $ nimtetris

Key bindings
------------

Vim like key-bindings.

=============== ===================
Key             Motion
=============== ===================
H               Move left
J               Move down
L               Move right
U               Rotate left
O               Rotate right
<Space>/<Enter> Move down to bottom
=============== ===================

Installation
============

.. code-block:: shell

   $ nimble install -Y nimtetris

or

Download from `Releases <https://github.com/jiro4989/nimtetris/releases>`_.

LICENSE
=======

MIT

.. |gh-actions| image:: https://github.com/jiro4989/nimtetris/workflows/build/badge.svg
   :target: https://github.com/jiro4989/nimtetris/actions
.. |nimble-version| image:: https://nimble.directory/ci/badges/nimtetris/version.svg
   :target: https://nimble.directory/ci/badges/nimtetris/nimdevel/output.html
.. |nimble-install| image:: https://nimble.directory/ci/badges/nimtetris/nimdevel/status.svg
   :target: https://nimble.directory/ci/badges/nimtetris/nimdevel/output.html
.. |demo-linux| image:: https://user-images.githubusercontent.com/13825004/85021658-1a7bc900-b1ad-11ea-9e53-c23c3841a518.gif
.. |demo-win| image:: https://user-images.githubusercontent.com/13825004/85021667-1c458c80-b1ad-11ea-9609-46f30a4b7be7.gif
