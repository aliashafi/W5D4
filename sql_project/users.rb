require_relative 'users'
require_relative 'replies'
require_relative 'questions_database'


class Users
  attr_accessor :fname, :lname, :id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new(datum) }
  end

  def self.find_by_id(id)
     user = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    Users.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    Users.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    ## GOAL: find all questions that id has created
    Questions.find_by_id(@id)
  end

  def authored_replies
    reply = Replies.find_user_by_id(@id)

    if reply.nil?
      raise 'User did not reply!'
    end

    reply
  end

  def followed_questions
    QuestionFollows.followers_questions_for_user_id(@id)
  end
end