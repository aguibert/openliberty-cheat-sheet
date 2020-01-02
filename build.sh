#!/bin/bash
asciidoctor -a favicon=images/favicon.ico -a toc=left -a source-highlighter=highlightjs docs/index.adoc

