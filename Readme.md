# Basic PowerShell Functions

A collection of basic PowerShell functions.

## Nested Module

The implementation is written inside a nested module to allow `Import-UserModule` to reimport this module without errors.
Otherwise an AliasAlreadyExists exception is thrown for each alias defined in the module.
