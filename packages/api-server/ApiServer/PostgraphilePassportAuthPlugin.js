const { makeExtendSchemaPlugin, gql } = require("graphile-utils");

exports.mkPassportLoginPlugin = mkResolvers => makeExtendSchemaPlugin(build => ({
  typeDefs: gql`
    input WebRegisterInput {
      username: String!
      email: String!
      password: String!
      name: String
      avatarUrl: String
    }

    type WebRegisterPayload {
      user: User! @pgField
    }

    input WebLoginInput {
      username: String!
      password: String!
    }

    type WebLoginPayload {
      user: User! @pgField
    }

    extend type Mutation {
      webRegister(input: WebRegisterInput!): WebRegisterPayload
      webLogin(input: WebLoginInput!): WebLoginPayload
    }
  `,
  resolvers: mkResolvers(build)
}));

exports.mkSelectGraphQLResultFromTable = (user_id, sql) =>
  (tableAlias, sqlBuilder) => {
    sqlBuilder.where(
      sql.fragment`${tableAlias}.id = ${sql.value(user_id)}`
    )
  }

exports.appPublicUsersFragment = fragment => fragment`app_public.users`
