const { makeExtendSchemaPlugin, gql } = require("graphile-utils");

exports.passportLoginPlugin = makeExtendSchemaPlugin(build => ({
  typeDefs: gql`
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
  `,
  resolvers: {
    Mutation: {
      register: require("./PassportLoginPluginAsyncFunctions.js").register,
      login: require("./PassportLoginPluginAsyncFunctions.js").login
    },
  },
}));
