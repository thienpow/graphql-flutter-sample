class QueryMutation {
  String createUser(String name, String lastName, int phone) {
    return """
      mutation{
          createUser(
            data: {
              name: "$name", lastName: "$lastName", phone: $phone
            }
          ) {
            id
            lastName
          }
      }
    """;
  }

  String getAll(){
    return """ 
      {
        users{
          id
          name
          lastName
          phone
        }
      }
    """;
  }

  String deleteUser(id){
    return """
      mutation{
        deleteUser( where: {
          id: "$id"
        }) {
          id
          lastName
        }
      } 
    """;
  }

  String updateUser(String id, String name, String lastName, int phone){
    return """
      mutation{
          updateUser(
            data: {
              name: "$name", lastName: "$lastName", phone: $phone
            }
            where: {
              id: "$id"
            }
          ) {
            id
            lastName
          }
      }    
     """;
  }
}