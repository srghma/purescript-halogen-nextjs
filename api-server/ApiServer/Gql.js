const { makeExtendSchemaPlugin, gql } = require("graphile-utils");

exports.typeDefs = gql`
  input RegisterInput {
    username: String!
    email: String!
    password: String!
    name: String
    avatarUrl: String
  }
  type RegisterPayload {
    user: User! @pgField
  }
  input LoginInput {
    username: String!
    password: String!
  }
  type LoginPayload {
    user: User! @pgField
  }
  extend type Mutation {
    register(input: RegisterInput!): RegisterPayload
    login(input: LoginInput!): LoginPayload
  }
`
