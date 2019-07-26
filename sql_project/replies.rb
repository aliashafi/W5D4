require_relative 'users'
require_relative 'replies'
require_relative 'questions_database'


class Replies
  attr_accessor :question, :body_reply, :user_id, :parent

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_id(id)
     reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Replies.new(reply.first)
  end

  def self.find_user_by_id(id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    raise 'id not in replies table' if reply.nil?
    Replies.new(reply.first)
  end

  def self.find_by_questions(title)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL

    raise 'id not in replies table' if reply.nil?
    Replies.new(reply.first)
  end

  def initialize(options)
    @id = options['id']
    @question = options['question']
    @body_reply = options['body_reply']
    @user_id = options['user_id']
    @parent = options['parent']
  end

  def author
    Users.find_by_id(@user_id)
  end

  def parent_reply
    Replies.find_by_id(@parent)
  end

  def child_replies
    reply = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent = ?
    SQL

    raise 'id not in replies table' if reply.nil?

    reply

  end


end

if $PROGRAM_NAME == __FILE__
  reply = Replies.find_by_id(1)
  p reply.child_replies
end