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
H / A           Move left
J / S           Move down
L / D           Move right
U / Q           Rotate left
O / E           Rotate right
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
.. |demo-linux| image:: https://user-images.githubusercontent.com/13825004/85140962-01dce300-b281-11ea-9473-2d558c0881c0.gif
.. |demo-win| image:: https://user-images.githubusercontent.com/13825004/85021667-1c458c80-b1ad-11ea-9609-46f30a4b7be7.gif
