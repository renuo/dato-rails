# frozen_string_literal: true

attributes = {author: "John Doe", tags: "tag1,tag2,tag3"}
meta = {en: {title: "Static Random Image", alt: "some caption text"}}

Dato::Client.new.uploads.create(path_to_file: file.path, attributes:, meta:)
