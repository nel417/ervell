import gql from 'graphql-tag'

export default gql`
  query BlogPostBySlugQuery($slug: String!) {
    blogPostCollection(where: { slug: $slug }) {
      items {
        __typename
        sys {
          id
        }
        slug
        title
        category
        image {
          small: url(transform: { width: 250 })
          medium: url(transform: { width: 500 })
          large: url(transform: { width: 750 })
        }
        previewText
        displayDate
        author {
          name
          bio {
            json
          }
        }
        body {
          json
        }
      }
    }
  }
`
