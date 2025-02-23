from setuptools import find_packages, setup

setup(
    name="osc-sdk",
    version="1.6",
    packages=find_packages(),
    author="Outscale SAS",
    author_email="contact@outscale.com",
    description="Outscale API SDK and CLI",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    license='BSD',
    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Operating System :: OS Independent',
    ],
    url="https://github.com/outscale/osc-cli",
    entry_points={"console_scripts": ["osc-cli = osc_sdk.sdk:main"]},
    install_requires=[
        "setuptools",
        "defusedxml==0.7.1",
        "fire==0.1.3",
        "requests==2.26.0",
        "xmltodict==0.11.0",
    ],
)
