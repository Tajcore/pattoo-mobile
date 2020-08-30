class AgentFetch {
  String translateAgent = """
query{
  allAgentXlate {
    edges {
      node {
        agentProgram
        translation
      }
    }
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
  }
}

""";
  String createChart = """
mutation CreateChart(\$name:String) {
  createChart(Input: {name: \$name}) {
    chart {
      id
      name
      idxChart
      enabled
    }
  }
}
""";

  String modifyChartNamne = """
mutation ModifyChartName(\$name:String!,\$id:String!) {
  updateChart(Input: {idxChart: \$id,name: \$name}) {
    chart {
      id
      idxChart
      name
      enabled
    }
  }
}
""";

  String deleteChart = """
mutation DeleteChart(\$id:String) {
  updateChart(Input: {idxChart: \$id,enabled:"0"}) {
    chart {
      id
      idxChart
      name
      enabled
    }
  }
}
""";
  String addChartDataPoint = """
mutation addDatapoint(\$idxDatapoint:String,\$idxChart:String){
  createChartDataPoint(Input: {idxDatapoint: \$idxDatapoint, idxChart: \$idxChart}) {
    chartDatapoint {
      id
      idxChartDatapoint
      idxDatapoint
      idxChart
    }
  }
}
""";
  String deleteChartDatapoint = """
mutation addDatapoint(\$idxChartDatapoint:String,\$idxChart){
  updateChartDataPoint(Input: {idxChartDatapoint: \$idxChartDatapoint, idxChart: \$idxChart,enabled:"0"}) {
    chartDatapoint {
      id
      idxChartDatapoint
      idxDatapoint
      idxChart
      enabled
    }
  }
}
""";


  String Authentication = """
  query AuthenticateUser(\$username:String!, \$password:String!){
    authenticate(username: \$username, password: \$password) {
    	id
  	}
  }
  
  """;

  String updateFavouriteOrder = """
  mutation updateOrder(\$idxFavorite:String!, \$order:String!){
  updateFavorite(Input: {idxFavorite: \$idxFavorite, order: \$order}) {
    favorite {
      idxFavorite
      idxChart
      idxUser
      enabled
    }
  }
}
""";
  String createFavouriteChart = """
  mutation createFav(\$idxUser:String! \$idxChart:String!, \$order:String!  ) {
  createFavorite(Input: {idxUser:\$idxUser, idxChart: \$idxChart, order:\$order}) {
    favorite{
      id
      idxFavorite
      idxChart
      idxUser
      enabled
    }
  }
}
 """;

  String removeFavouriteChart = """
  mutation removeFavourite(\$idxFavorite:String!) {
  updateFavorite(Input: {idxFavorite: \$idxFavorite, enabled:"0"}) {
    favorite {
      idxFavorite
      idxChart
      idxUser
      enabled
    }
  }
} 
""";

  String getUserInfo = """
  query getUserInfo(\$username:String!){
  allUser(username:\$username){
    edges{
      node{
        idxUser
        username
        firstName
        lastName
      }
    }
  }
} """;
  String getAllAgents = """
query getAllAgents(\$cursor: String) {
  allAgent(first: 12, after: \$cursor) {
    edges {
      node {
        id
        agentProgram
        idxAgent
        idxPairXlateGroup
        pairXlateGroup {
          pairXlatePairXlateGroup {
            edges {
              node {
                idxPairXlate
                key
                translation
                units
              }
            }
          }
        }
      }
    }
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
  }
}
""";

  String getTranslatedDataPointAgentName = """
query getTranslatedDataPoints(\$id: String){
  allPairXlate(idxPairXlate:\$id) {
    edges {
      node {
        id
        translation
      }
    }
  }
}



""";
  String getAllCharts = """
query getAllCharts{
  allChart(enabled:"1"){
    edges{
      node{
        name
        idxChart
        chartDatapointChart{
          edges{
            node{
              idxChartDatapoint
              datapoint{
                idxDatapoint
                idxAgent
                glueDatapoint{
                  edges{
                    node{
                      pair{
                        key
                        value
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
""";

  String getDataPointAgents = """
query getDataPoints(\$id: String, \$cursor: String){
  allDatapoints(idxAgent:\$id, first:12, after:\$cursor) {
    edges {
      node {
        idxAgent
        idxDatapoint
				glueDatapoint{
          edges{
            node{
      				idxPair
              idxDatapoint
              pair{
                key
                value
              }
            }
          }
        }
      }
    }
    pageInfo{
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
  }
}

""";
  String getTimeData = """
query getTimeSeries(\$id: String){
  allDatapoints(idxDatapoint:\$id) {
    edges {
				node{
          dataChecksum(last:1000000){
            edges{
              node{
                value
                timestamp
                }
              }
            }
        }
    }
  }
}

""";

//Favourites

  String getFavoriteData = """
        query getFavoriteData(\$username: String)
        {
          allUser(username: \$username) {
 edges {
      node {
        id
        idxUser
        username
        favoriteUser {
          edges {
            node {
              order
              enabled
              idxFavorite
              chart {
                idxChart
                name
                enabled
                chartDatapointChart {
                  edges {
                    node {
                      idxChartDatapoint
                      datapoint {
                        idxDatapoint
                        idxAgent
                        glueDatapoint {
                          edges {
                            node {
                              pair {
                                key
                                value
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    pageInfo {
      startCursor
      endCursor
      hasNextPage
      hasPreviousPage
    }
          }
        }
        """;

  String addFavourite = """
mutation {
  createFavorite(Input: {idxUser: "3", idxChart: "149", order: "2"}) {
    favorite {
      id
      idxFavorite
      idxChart
      idxUser
      enabled
    }
  }
}
""";
}
