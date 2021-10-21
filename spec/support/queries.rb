def homepage_query
  GQLi::DSL.query {
    homepage {
      id
      _createdAt
      _seoMetaTags {
        attributes
        content
        tag
      }
      content {
        value
        blocks {
          id
          image {
            responsiveImage(imgixParams: {fm: __enum("png")}) {
              ___ Dato::Fragments::ResponsiveImage
            }
          }
        }
      }
    }
  }
end

def posts_query
  GQLi::DSL.query {
    allPosts {
      id
      title
      slug
      author {
        name
        id
        picture {
          responsiveImage(imgixParams: {fm: __enum("png")}) {
            ___ Dato::Fragments::ResponsiveImage
          }
        }
      }
    }
  }
end
