using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ADONETHomework
{
    class Program
    {
        private static string connectionString = ConfigurationManager.ConnectionStrings["SqlConnectionString"].ConnectionString;

        private static SqlDataAdapter dataAdapter;

        public static DataTable UsersDataTable = new DataTable("Users");
        public static DataTable CredentialsDataTable = new DataTable("UserCredentials");
        static void Main(string[] args)
        {
            using (var sqlConnection = new SqlConnection(connectionString))
            {
                sqlConnection.Open();
                var queryForUsersTable = "CREATE TABLE Users(" +
                                         "Id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, " +
                                         "FirstName VARCHAR(50) NOT NULL, " +
                                         "LastName VARCHAR(50) NOT NULL)";
                var queryForCredentialsTable = "CREATE TABLE UserCredentials(" +
                                               "Id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY, " +
                                               "Username VARCHAR(15) NOT NULL UNIQUE, " +
                                               "Password VARCHAR(256) NOT NULL)";

                var queryAlterUserCredentialsTable = "ALTER TABLE Users ADD " +
                                                     "UserCredentialsId INT NULL " +
                                                     "REFERENCES UserCredentials";

                using (var sqlCommand = new SqlCommand(queryForUsersTable, sqlConnection))
                {
                    sqlCommand.ExecuteNonQuery();
                }

                using (var sqlCommand = new SqlCommand(queryForCredentialsTable, sqlConnection))
                {
                    sqlCommand.ExecuteNonQuery();
                }

                dataAdapter = new SqlDataAdapter(queryAlterUserCredentialsTable, connectionString);
                var insertUserQuery = "INSERT INTO PerspectiveCustomers " +
                                      "([users].[First_Name], [users].[Last_Name]) " +
                                      "VALUES(@FirstName, @LastName)";
                using (var sqlCommand = new SqlCommand(insertUserQuery))
                {
                    sqlCommand.Parameters.Add("@FirstName", SqlDbType.VarChar, 255, "Fiodor");
                    sqlCommand.Parameters.Add("@LastName", SqlDbType.VarChar, 255, "Marinescu");
                    dataAdapter.InsertCommand = sqlCommand;
                    
                }

                /*DataTable usersTable = new DataTable("Users");
                DataColumn firstNameColumn = new DataColumn("FirstName", typeof(char));
                DataColumn lastNameColumn = new DataColumn("LastName", typeof(char));
                DataColumn userCredentialsColumn = new DataColumn("UserCredentials", typeof(int));
                usersTable.Columns.Add(firstNameColumn);
                usersTable.Columns.Add(lastNameColumn);
                usersTable.Columns.Add(userCredentialsColumn);
                */
                DataSet dataSet = new DataSet();
                dataAdapter.Fill(dataSet);
                DataTable userTable = new DataTable();
                userTable = dataSet.Tables["Users"];
                var row = userTable.NewRow();
                row["FirstName"] = "Alex";
                userTable.Rows.Add(row);
                dataAdapter.Update(userTable);
            }
        }
    }
}
