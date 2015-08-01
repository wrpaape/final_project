all_methods =
[
  {
name: "create_with",
module: "ActiveRecord::QueryMethods",
syntax: ".create_with(value)",
description: "Sets attributes to be used when creating new records from a relation object.",
example: "users = User.where(name: 'Oscar')
users.new.name # => 'Oscar'

users = users.create_with(name: 'DHH')
users.new.name # => 'DHH'
You can pass nil to create_with to reset attributes:

users = users.create_with(nil)
users.new.name # => 'Oscar'",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 726
def create_with(value)
  spawn.create_with!(value)
end"
  },
  {
name: "distinct",
module: "ActiveRecord::QueryMethods",
syntax: ".distinct(value = true)",
description: "Specifies whether the records should be unique or not. Also aliased as: uniq.",
example: "User.select(:name)
# => Might return two records with the same name

User.select(:name).distinct
# => Returns 1 record per distinct name

User.select(:name).distinct.distinct(false)
# => You can also remove the uniqueness",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 776
def distinct(value = true)
  spawn.distinct!(value)
end"
  },
  {
name: "eager_load",
module: "ActiveRecord::QueryMethods",
syntax: ".eager_load(*args)",
description: "Forces eager loading by performing a LEFT OUTER JOIN on args.",
example: 'User.eager_load(:posts)
=> SELECT "users"."id" AS t0_r0, "users"."name" AS t0_r1, ...
FROM "users" LEFT OUTER JOIN "posts" ON "posts"."user_id" =
"users"."id"',
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 163
def eager_load(*args)
  check_if_method_has_arguments!(:eager_load, args)
  spawn.eager_load!(*args)
end"
  },
  {
name: "extending",
module: "ActiveRecord::QueryMethods",
syntax: ".extending(*modules, &block)",
description: "Used to extend a scope with additional methods, either through a module or through a block provided.

The object returned is a relation, which can be further extended.",
example: "Using a module

module Pagination
  def page(number)
    # pagination code goes here
  end
end

scope = Model.all.extending(Pagination)
scope.page(params[:page])
You can also pass a list of modules:

scope = Model.all.extending(Pagination, SomethingElse)
Using a block

scope = Model.all.extending do
  def page(number)
    # pagination code goes here
  end
end
scope.page(params[:page])
You can also use a block and a module list:

scope = Model.all.extending(Pagination) do
  def per_page(number)
    # pagination code goes here
  end
end",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 824
def extending(*modules, &block)
  if modules.any? || block
    spawn.extending!(*modules, &block)
  else
    self
  end
end"
  },
  {
name: "from",
module: "ActiveRecord::QueryMethods",
syntax: ".from(value, subquery_name = nil)",
description: "Specifies table from which the records will be fetched.",
example: "Topic.select('title').from('posts')
# => SELECT title FROM posts
Can accept other relation objects. For example:

Topic.select('title').from(Topic.approved)
# => SELECT title FROM (SELECT * FROM topics WHERE approved = 't') subquery

Topic.select('a.title').from(Topic.approved, :a)
# => SELECT a.title FROM (SELECT * FROM topics WHERE approved = 't') a",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 754
def from(value, subquery_name = nil)
  spawn.from!(value, subquery_name)
end"
  },
  {
name: "group",
module: "ActiveRecord::QueryMethods",
syntax: ".group(*args)",
description: "Allows to specify a group attribute.",
example: 'User.group(:name)
=> SELECT "users".* FROM "users" GROUP BY name
Returns an array with distinct records based on the group attribute:

User.select([:id, :name])
=> [#<User id: 1, name: "Oscar">, #<User id: 2, name: "Oscar">, #<User id: 3, name: "Foo">

User.group(:name)
=> [#<User id: 3, name: "Foo", ...>, #<User id: 2, name: "Oscar", ...>]

User.group(\'name AS grouped_name, age\')
=> [#<User id: 3, name: "Foo", age: 21, ...>, #<User id: 2, name: "Oscar", age: 21, ...>, #<User id: 5, name: "Foo", age: 23, ...>]
Passing in an array of attributes to group by is also supported.

User.select([:id, :first_name]).group(:id, :first_name).first(3)
=> [#<User id: 1, first_name: "Bill">, #<User id: 2, first_name: "Earl">, #<User id: 3, first_name: "Beto">]',
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 286
def group(*args)
  check_if_method_has_arguments!(:group, args)
  spawn.group!(*args)
end"
  },
  {
name: "having",
module: "ActiveRecord::QueryMethods",
syntax: ".having(opts, *rest)",
description: "Allows to specify a HAVING clause. Note that you can't use HAVING without also specifying a GROUP clause.",
example: "Order.having('SUM(price) > 30').group('user_id')",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 604
def having(opts, *rest)
  opts.blank? ? self : spawn.having!(opts, *rest)
end"
  },
  {
name: "includes",
module: "ActiveRecord::QueryMethods",
syntax: ".includes(*args)",
description: "Specify relationships to be included in the result set.",
example: "users = User.includes(:address)
users.each do |user|
  user.address.city
end
allows you to access the address attribute of the User model without firing an additional query. This will often result in a performance improvement over a simple join.

You can also specify multiple relationships, like this:

users = User.includes(:address, :friends)
Loading nested relationships is possible using a Hash:

users = User.includes(:address, friends: [:address, :followers])
conditions

If you want to add conditions to your included models you'll have to explicitly reference them. For example:

User.includes(:posts).where('posts.name = ?', 'example')
Will throw an error, but this will work:

User.includes(:posts).where('posts.name = ?', 'example').references(:posts)
Note that includes works with association names while references needs the actual table name.",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 144
def includes(*args)
  check_if_method_has_arguments!(:includes, args)
  spawn.includes!(*args)
end"
  },
  {
name: "joins",
module: "ActiveRecord::QueryMethods",
syntax: ".joins(*args)",
description: "Performs a joins on args.",
example: 'User.joins(:posts)
=> SELECT "users".* FROM "users" INNER JOIN "posts" ON "posts"."user_id" = "users"."id"
You can use strings in order to customize your joins:

User.joins("LEFT JOIN bookmarks ON bookmarks.bookmarkable_type = \'Post\' AND bookmarks.user_id = users.id")
=> SELECT "users".* FROM "users" LEFT JOIN bookmarks ON bookmarks.bookmarkable_type = \'Post\' AND bookmarks.user_id = users.id',
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 428
def joins(*args)
  check_if_method_has_arguments!(:joins, args)
  spawn.joins!(*args)
end"
  },
  {
name: "limit",
module: "ActiveRecord::QueryMethods",
syntax: ".limit(value)",
description: "Specifies a limit for the number of records to retrieve.",
example: "User.limit(10) # generated SQL has 'LIMIT 10'

User.limit(10).limit(20) # generated SQL has 'LIMIT 20'",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 620
def limit(value)
  spawn.limit!(value)
end"
  },
  {
name: "lock",
module: "ActiveRecord::QueryMethods",
syntax: ".lock(locks = true)",
description: "Specifies locking settings (default to true). For more information on locking, please see ActiveRecord::Locking.",
example: nil,
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 647
def lock(locks = true)
  spawn.lock!(locks)
end"
  },
  {
name: "none",
module: "ActiveRecord::QueryMethods",
syntax: ".none()",
description: "Returns a chainable relation with zero records.

The returned relation implements the Null Object pattern. It is an object with defined null behavior and always returns an empty array of records without querying the database.

Any subsequent condition chained to the returned relation will continue generating an empty relation and will not fire any query to the database.

Used in cases where a method or scope could return zero records but the result needs to be chainable.",
example: "@posts = current_user.visible_posts.where(name: params[:name])
# => the visible_posts method is expected to return a chainable Relation

def visible_posts
  case role
  when 'Country Manager'
    Post.where(country: country)
  when 'Reviewer'
    Post.published
  when 'Bad User'
    Post.none # It can't be chained if [] is returned.
  end
end",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 690
def none
  where(\"1=0\").extending!(NullRelation)
end"
  },
  {
name: "offset",
module: "ActiveRecord::QueryMethods",
syntax: ".offset(value)",
description: "Specifies the number of rows to skip before returning rows.",
example: "User.offset(10) # generated SQL has \"OFFSET 10\"
Should be used with order.

User.offset(10).order(\"name ASC\")",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 636
def offset(value)
  spawn.offset!(value)
end"
  },
  {
name: "order",
module: "ActiveRecord::QueryMethods",
syntax: ".order(*args)",
description: "Allows to specify an order attribute.",
example: 'User.order(:name)
=> SELECT "users".* FROM "users" ORDER BY "users"."name" ASC

User.order(email: :desc)
=> SELECT "users".* FROM "users" ORDER BY "users"."email" DESC

User.order(:name, email: :desc)
=> SELECT "users".* FROM "users" ORDER BY "users"."name" ASC, "users"."email" DESC

User.order(\'name\')
=> SELECT "users".* FROM "users" ORDER BY name

User.order(\'name DESC\')
=> SELECT "users".* FROM "users" ORDER BY name DESC

User.order(\'name DESC, email\')
=> SELECT "users".* FROM "users" ORDER BY name DESC, email',
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 317
def order(*args)
  check_if_method_has_arguments!(:order, args)
  spawn.order!(*args)
end"
  },
  {
name: "preload",
module: "ActiveRecord::QueryMethods",
syntax: ".preload(*args)",
description: "Allows preloading of args, in the same way that includes does.",
example: 'User.preload(:posts)
=> SELECT "posts".* FROM "posts" WHERE "posts"."user_id" IN (1, 2, 3)',
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 177
def preload(*args)
  check_if_method_has_arguments!(:preload, args)
  spawn.preload!(*args)
end"
  },
  {
name: "readonly",
module: "ActiveRecord::QueryMethods",
syntax: ".readonly(value = true)",
description: "Sets readonly attributes for the returned relation. If value is true (default), attempting to update a record will result in an error.",
example: "users = User.readonly
users.first.save
=> ActiveRecord::ReadOnlyRecord: ActiveRecord::ReadOnlyRecord",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 704
def readonly(value = true)
  spawn.readonly!(value)
end"
  },
  {
name: "references",
module: "ActiveRecord::QueryMethods",
syntax: ".references(*table_names)",
description: "Use to indicate that the given table_names are referenced by an SQL string, and should therefore be JOINed in any query rather than loaded separately. This method only works in conjunction with includes. See includes for more details.",
example: "User.includes(:posts).where(\"posts.name = 'foo'\")
# => Doesn't JOIN the posts table, resulting in an error.

User.includes(:posts).where(\"posts.name = 'foo'\").references(:posts)
# => Query now knows the string references posts, so adds a JOIN",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 197
def references(*table_names)
  check_if_method_has_arguments!(:references, table_names)
  spawn.references!(*table_names)
end"
  },
  {
name: "reorder",
module: "ActiveRecord::QueryMethods",
syntax: ".reorder(*args)",
description: "Replaces any existing order defined on the relation with the specified order.",
example: "User.order('email DESC').reorder('id ASC') # generated SQL has 'ORDER BY id ASC'
Subsequent calls to order on the same relation will be appended. For example:

User.order('email DESC').reorder('id ASC').order('name ASC')
generates a query with 'ORDER BY id ASC, name ASC'.",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 338
def reorder(*args)
  check_if_method_has_arguments!(:reorder, args)
  spawn.reorder!(*args)
end"
  },
  {
name: "reverse_order",
module: "ActiveRecord::QueryMethods",
syntax: ".reverse_order()",
description: "Reverse the existing order clause on the relation.",
example: "User.order('name ASC').reverse_order # generated SQL has 'ORDER BY name DESC'",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 845
def reverse_order
  spawn.reverse_order!
end"
  },
  {
name: "rewhere",
module: "ActiveRecord::QueryMethods",
syntax: ".rewhere(conditions)",
description: "Allows you to change a previously set where condition for a given attribute, instead of appending to that condition.",
example: "Post.where(trashed: true).where(trashed: false)                       # => WHERE `trashed` = 1 AND `trashed` = 0
Post.where(trashed: true).rewhere(trashed: false)                     # => WHERE `trashed` = 0
Post.where(active: true).where(trashed: true).rewhere(trashed: false) # => WHERE `active` = 1 AND `trashed` = 0
This is short-hand for unscope(where: conditions.keys).where(conditions). Note that unlike reorder, we're only unscoping the named conditions – not the entire where statement.",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 596
def rewhere(conditions)
  unscope(where: conditions.keys).where(conditions)
end"
  },
  {
name: "select",
module: "ActiveRecord::QueryMethods",
syntax: ".select(*fields)",
description: "Works in two unique ways.

First: takes a block so it can be used just like Array#select.

Second: Modifies the SELECT statement for the query so that only certain fields are retrieved.",
example: "First: takes a block so it can be used just like Array#select.

Model.all.select { |m| m.field == value }
This will build an array of objects from the database for the scope, converting them into an array and iterating through them using Array#select.

Second: Modifies the SELECT statement for the query so that only certain fields are retrieved:

Model.select(:field)
# => [#<Model id: nil, field: \"value\">]
Although in the above example it looks as though this method returns an array, it actually returns a relation object and can have other query methods appended to it, such as the other methods in ActiveRecord::QueryMethods.

The argument to the method can also be an array of fields.

Model.select(:field, :other_field, :and_one_more)
# => [#<Model id: nil, field: \"value\", other_field: \"value\", and_one_more: \"value\">]
You can also use one or more strings, which will be used unchanged as SELECT fields.

Model.select('field AS field_one', 'other_field AS field_two')
# => [#<Model id: nil, field: \"value\", other_field: \"value\">]
If an alias was specified, it will be accessible from the resulting objects:

Model.select('field AS field_one').first.field_one
# => \"value\"
Accessing attributes of an object that do not have fields retrieved by a select except id will throw ActiveModel::MissingAttributeError:

Model.select(:field).first.other_field
# => ActiveModel::MissingAttributeError: missing attribute: other_field",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 249
def select(*fields)
  if block_given?
    to_a.select { |*block_args| yield(*block_args) }
  else
    raise ArgumentError, 'Call this with at least one field' if fields.empty?
    spawn._select!(*fields)
  end
end"
  },
  {
name: "uniq",
module: "ActiveRecord::QueryMethods",
syntax: ".uniq(value = true)",
description: "Alias for: distinct",
example: nil,
source: nil
  },
  {
name: "unscope",
module: "ActiveRecord::QueryMethods",
syntax: ".unscope(*args)",
description: "Removes an unwanted relation that is already defined on a chain of relations. This is useful when passing around chains of relations and would like to modify the relations without reconstructing the entire chain.",
example: "User.order('email DESC').unscope(:order) == User.all
The method arguments are symbols which correspond to the names of the methods which should be unscoped. The valid arguments are given in VALID_UNSCOPING_VALUES. The method can also be called with multiple arguments. For example:

User.order('email DESC').select('id').where(name: \"John\")
    .unscope(:order, :select, :where) == User.all
One can additionally pass a hash as an argument to unscope specific :where values. This is done by passing a hash with a single key-value pair. The key should be :where and the value should be the where value to unscope. For example:

User.where(name: \"John\", active: true).unscope(where: :name)
    == User.where(active: true)
This method is similar to except, but unlike except, it persists across merges:

User.order('email').merge(User.except(:order))
    == User.order('email')

User.order('email').merge(User.unscope(:order))
    == User.all
This means it can be used in association definitions:

has_many :comments, -> { unscope where: :trashed }",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 388
def unscope(*args)
  check_if_method_has_arguments!(:unscope, args)
  spawn.unscope!(*args)
end"
  },
  {
name: "where",
module: "ActiveRecord::QueryMethods",
syntax: ".where(opts = :chain, *rest)",
description: "Returns a new relation, which is the result of filtering the current relation according to the conditions in the arguments.

where accepts conditions in one of several formats. In the examples below, the resulting SQL is given as an illustration; the actual query generated may be different depending on the database adapter.",
example: "string

A single string, without additional arguments, is passed to the query constructor as an SQL fragment, and used in the where clause of the query.

Client.where(\"orders_count = '2'\")
# SELECT * from clients where orders_count = '2';
Note that building your own string from user input may expose your application to injection attacks if not done properly. As an alternative, it is recommended to use one of the following methods.

array

If an array is passed, then the first element of the array is treated as a template, and the remaining elements are inserted into the template to generate the condition. Active Record takes care of building the query to avoid injection attacks, and will convert from the ruby type to the database type where needed. Elements are inserted into the string in the order in which they appear.

User.where([\"name = ? and email = ?\", \"Joe\", \"joe@example.com\"])
# SELECT * FROM users WHERE name = 'Joe' AND email = 'joe@example.com';
Alternatively, you can use named placeholders in the template, and pass a hash as the second element of the array. The names in the template are replaced with the corresponding values from the hash.

User.where([\"name = :name and email = :email\", { name: \"Joe\", email: \"joe@example.com\" }])
# SELECT * FROM users WHERE name = 'Joe' AND email = 'joe@example.com';
This can make for more readable code in complex queries.

Lastly, you can use sprintf-style % escapes in the template. This works slightly differently than the previous methods; you are responsible for ensuring that the values in the template are properly quoted. The values are passed to the connector for quoting, but the caller is responsible for ensuring they are enclosed in quotes in the resulting SQL. After quoting, the values are inserted using the same escapes as the Ruby core method Kernel::sprintf.

User.where([\"name = '%s' and email = '%s'\", \"Joe\", \"joe@example.com\"])
# SELECT * FROM users WHERE name = 'Joe' AND email = 'joe@example.com';
If where is called with multiple arguments, these are treated as if they were passed as the elements of a single array.

User.where(\"name = :name and email = :email\", { name: \"Joe\", email: \"joe@example.com\" })
# SELECT * FROM users WHERE name = 'Joe' AND email = 'joe@example.com';
When using strings to specify conditions, you can use any operator available from the database. While this provides the most flexibility, you can also unintentionally introduce dependencies on the underlying database. If your code is intended for general consumption, test with multiple database backends.

hash

where will also accept a hash condition, in which the keys are fields and the values are values to be searched for.

Fields can be symbols or strings. Values can be single values, arrays, or ranges.

User.where({ name: \"Joe\", email: \"joe@example.com\" })
# SELECT * FROM users WHERE name = 'Joe' AND email = 'joe@example.com'

User.where({ name: [\"Alice\", \"Bob\"]})
# SELECT * FROM users WHERE name IN ('Alice', 'Bob')

User.where({ created_at: (Time.now.midnight - 1.day)..Time.now.midnight })
# SELECT * FROM users WHERE (created_at BETWEEN '2012-06-09 07:00:00.000000' AND '2012-06-10 07:00:00.000000')
In the case of a belongs_to relationship, an association key can be used to specify the model if an ActiveRecord object is used as the value.

author = Author.find(1)

# The following queries will be equivalent:
Post.where(author: author)
Post.where(author_id: author)
This also works with polymorphic belongs_to relationships:

treasure = Treasure.create(name: 'gold coins')
treasure.price_estimates << PriceEstimate.create(price: 125)

# The following queries will be equivalent:
PriceEstimate.where(estimate_of: treasure)
PriceEstimate.where(estimate_of_type: 'Treasure', estimate_of_id: treasure)
Joins

If the relation is the result of a join, you may create a condition which uses any of the tables in the join. For string and array conditions, use the table name in the condition.

User.joins(:posts).where(\"posts.created_at < ?\", Time.now)
For hash conditions, you can either use the table name in the key, or use a sub-hash.

User.joins(:posts).where({ \"posts.published\" => true })
User.joins(:posts).where({ posts: { published: true } })
no argument

If no argument is passed, where returns a new instance of WhereChain, that can be chained with not to return a new relation that negates the where clause.

User.where.not(name: \"Jon\")
# SELECT * FROM users WHERE name != 'Jon'
See WhereChain for more details on not.

blank condition

If the condition is any blank-ish object, then where is a no-op and returns the current relation.",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 568
def where(opts = :chain, *rest)
  if opts == :chain
    WhereChain.new(spawn)
  elsif opts.blank?
    self
  else
    spawn.where!(opts, *rest)
  end
end"
  },
  {
name: "exists?",
module: "ActiveRecord::FinderMethods",
syntax: ".exists?(conditions = :none)",
description: "Returns true if a record exists in the table that matches the id or conditions given, or false otherwise.",
example: "The argument can take six forms:

Integer - Finds the record with this primary key.

String - Finds the record with a primary key corresponding to this string (such as '5').

Array - Finds the record that matches these find-style conditions (such as ['name LIKE ?', \"%#\{query}%\"]).

Hash - Finds the record that matches these find-style conditions (such as {name: 'David'}).

false - Returns always false.

No args - Returns false if the table is empty, true otherwise.

For more information about specifying conditions as a hash or array, see the Conditions section in the introduction to ActiveRecord::Base.

Note: You can't pass in a condition as a string (like name = 'Jamie'), since it would be sanitized and then queried against the primary key column, like id = 'name = \'Jamie\''.

Person.exists?(5)
Person.exists?('5')
Person.exists?(['name LIKE ?', \"%#\{query}%\"])
Person.exists?(id: [1, 4, 8])
Person.exists?(name: 'David')
Person.exists?(false)
Person.exists?",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 277
    def exists?(conditions = :none)
      if Base === conditions
        conditions = conditions.id
        ActiveSupport::Deprecation.warn(\"          You are passing an instance of ActiveRecord::Base to `exists?`.
          Please pass the id of the object by calling `.id`
\".squish)
      end

      return false if !conditions

      relation = apply_join_dependency(self, construct_join_dependency)
      return false if ActiveRecord::NullRelation === relation

      relation = relation.except(:select, :order).select(ONE_AS_ONE).limit(1)

      case conditions
      when Array, Hash
        relation = relation.where(conditions)
      else
        unless conditions == :none
          relation = relation.where(primary_key => conditions)
        end
      end

      connection.select_value(relation, \"#\{name} Exists\", relation.arel.bind_values + relation.bind_values) ? true : false
    end"
  },
  {
name: "fifth",
module: "ActiveRecord::FinderMethods",
syntax: ".fifth()",
description: "Find the fifth record. If no order is defined it will order by primary key.",
example: "Person.fifth # returns the fifth object fetched by SELECT * FROM people
Person.offset(3).fifth # returns the fifth object from OFFSET 3 (which is OFFSET 7)
Person.where([\"user_name = :u\", { u: user_name }]).fifth",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 224
def fifth
  find_nth(4, offset_index)
end"
  },
  {
name: "fifth!",
module: "ActiveRecord::FinderMethods",
syntax: ".fifth!()",
description: "Same as fifth but raises ActiveRecord::RecordNotFound if no record is found.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 230
def fifth!
  find_nth! 4
end"
  },
  {
name: "find",
module: "ActiveRecord::FinderMethods",
syntax: ".find(*args)",
description: "Find by id - This can either be a specific id (1), a list of ids (1, 5, 6), or an array of ids ([5, 6, 10]). If no record can be found for all of the listed ids, then RecordNotFound will be raised. If the primary key is an integer, find by id coerces its arguments using to_i.",
example: "Person.find(1)          # returns the object for ID = 1
Person.find(\"1\")        # returns the object for ID = 1
Person.find(\"31-sarah\") # returns the object for ID = 31
Person.find(1, 2, 6)    # returns an array for objects with IDs in (1, 2, 6)
Person.find([7, 17])    # returns an array for objects with IDs in (7, 17)
Person.find([1])        # returns an array for the object with ID = 1
Person.where(\"administrator = 1\").order(\"created_on DESC\").find(1)
ActiveRecord::RecordNotFound will be raised if one or more ids are not found.

NOTE: The returned records may not be in the same order as the ids you provide since database rows are unordered. You'd need to provide an explicit order option if you want the results are sorted.

Find with lock

Example for find with a lock: Imagine two concurrent transactions: each will read person.visits == 2, add 1 to it, and save, resulting in two saves of person.visits = 3. By locking the row, the second transaction has to wait until the first is finished; we get the expected person.visits == 4.

Person.transaction do
  person = Person.lock(true).find(1)
  person.visits += 1
  person.save!
end
Variations of find

Person.where(name: 'Spartacus', rating: 4)
# returns a chainable list (which can be empty).

Person.find_by(name: 'Spartacus', rating: 4)
# returns the first item or nil.

Person.where(name: 'Spartacus', rating: 4).first_or_initialize
# returns the first item or returns a new instance (requires you call .save to persist against the database).

Person.where(name: 'Spartacus', rating: 4).first_or_create
# returns the first item or creates it and returns it, available since Rails 3.2.1.
Alternatives for find

Person.where(name: 'Spartacus', rating: 4).exists?(conditions = :none)
# returns a boolean indicating if any record with the given conditions exist.

Person.where(name: 'Spartacus', rating: 4).select(\"field1, field2, field3\")
# returns a chainable list of instances with only the mentioned fields.

Person.where(name: 'Spartacus', rating: 4).ids
# returns an Array of ids, available since Rails 3.2.1.

Person.where(name: 'Spartacus', rating: 4).pluck(:field1, :field2)
# returns an Array of the required fields, available since Rails 3.1.",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 67
def find(*args)
  if block_given?
    to_a.find(*args) { |*block_args| yield(*block_args) }
  else
    find_with_ids(*args)
  end
end"
  },
  {
name: "find_by",
module: "ActiveRecord::FinderMethods",
syntax: ".find_by(*args)",
description: "Finds the first record matching the specified conditions. There is no implied ordering so if order matters, you should specify it yourself.

If no record is found, returns nil.",
example: "Post.find_by name: 'Spartacus', rating: 4
Post.find_by \"published_at < ?\", 2.weeks.ago",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 83
def find_by(*args)
  where(*args).take
rescue RangeError
  nil
end"
  },
  {
name: "find_by!",
module: "ActiveRecord::FinderMethods",
syntax: ".find_by!(*args)",
description: "Like find_by, except that if no record is found, raises an ActiveRecord::RecordNotFound error.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 91
def find_by!(*args)
  where(*args).take!
rescue RangeError
  raise RecordNotFound, \"Couldn't find #\{@klass.name} with an out of range value\"
end"
  },
  {
name: "first",
module: "ActiveRecord::FinderMethods",
syntax: ".first(limit = nil)",
description: "Find the first record (or first N records if a parameter is supplied). If no order is defined it will order by primary key.",
example: "Person.first # returns the first object fetched by SELECT * FROM people ORDER BY people.id LIMIT 1
Person.where([\"user_name = ?\", user_name]).first
Person.where([\"user_name = :u\", { u: user_name }]).first
Person.order(\"created_on DESC\").offset(5).first
Person.first(3) # returns the first three objects fetched by SELECT * FROM people ORDER BY people.id LIMIT 3
",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 123
def first(limit = nil)
  if limit
    find_nth_with_limit(offset_index, limit)
  else
    find_nth(0, offset_index)
  end
end"
  },
  {
name: "first!",
module: "ActiveRecord::FinderMethods",
syntax: ".first!()",
description: "Same as first but raises ActiveRecord::RecordNotFound if no record is found. Note that first! accepts no arguments.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 133
def first!
  find_nth! 0
end"
  },
  {
name: "forty_two",
module: "ActiveRecord::FinderMethods",
syntax: ".forty_two()",
description: "Find the forty-second record. Also known as accessing \"the reddit\". If no order is defined it will order by primary key.",
example: "Person.forty_two # returns the forty-second object fetched by SELECT * FROM people
Person.offset(3).forty_two # returns the forty-second object from OFFSET 3 (which is OFFSET 44)
Person.where([\"user_name = :u\", { u: user_name }]).forty_two",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 240
def forty_two
  find_nth(41, offset_index)
end"
  },
  {
name: "forty_two!",
module: "ActiveRecord::FinderMethods",
syntax: ".forty_two!()",
description: "Same as forty_two but raises ActiveRecord::RecordNotFound if no record is found.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 246
def forty_two!
  find_nth! 41
end"
  },
  {
name: "fourth",
module: "ActiveRecord::FinderMethods",
syntax: ".fourth()",
description: "Find the fourth record. If no order is defined it will order by primary key.",
example: "Person.fourth # returns the fourth object fetched by SELECT * FROM people
Person.offset(3).fourth # returns the fourth object from OFFSET 3 (which is OFFSET 6)
Person.where([\"user_name = :u\", { u: user_name }]).fourth",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 208
def fourth
  find_nth(3, offset_index)
end"
  },
  {
name: "fourth!",
module: "ActiveRecord::FinderMethods",
syntax: ".fourth!()",
description: "Same as fourth but raises ActiveRecord::RecordNotFound if no record is found.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 214
def fourth!
  find_nth! 3
end"
  },
  {
name: "last",
module: "ActiveRecord::FinderMethods",
syntax: ".last(limit = nil)",
description: "Find the last record (or last N records if a parameter is supplied). If no order is defined it will order by primary key.",
example: "Person.last # returns the last object fetched by SELECT * FROM people
Person.where([\"user_name = ?\", user_name]).last
Person.order(\"created_on DESC\").offset(5).last
Person.last(3) # returns the last three objects fetched by SELECT * FROM people.
Take note that in that last case, the results are sorted in ascending order:

[#<Person id:2>, #<Person id:3>, #<Person id:4>]
and not:

[#<Person id:4>, #<Person id:3>, #<Person id:2>]",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 152
def last(limit = nil)
  if limit
    if order_values.empty? && primary_key
      order(arel_table[primary_key].desc).limit(limit).reverse
    else
      to_a.last(limit)
    end
  else
    find_last
  end
end"
  },
  {
name: "last!",
module: "ActiveRecord::FinderMethods",
syntax: ".last!()",
description: "Same as last but raises ActiveRecord::RecordNotFound if no record is found. Note that last! accepts no arguments.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 166
def last!
  last or raise RecordNotFound.new(\"Couldn't find #\{@klass.name} with [#\{arel.where_sql}]\")
end"
  },
  {
name: "second",
module: "ActiveRecord::FinderMethods",
syntax: ".second()",
description: "Find the second record. If no order is defined it will order by primary key.",
example: "Person.second # returns the second object fetched by SELECT * FROM people
Person.offset(3).second # returns the second object from OFFSET 3 (which is OFFSET 4)
Person.where([\"user_name = :u\", { u: user_name }]).second",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 176
def second
  find_nth(1, offset_index)
end"
  },
  {
name: "second!",
module: "ActiveRecord::FinderMethods",
syntax: ".second!()",
description: "Same as second but raises ActiveRecord::RecordNotFound if no record is found.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 182
def second!
  find_nth! 1
end"
  },
  {
name: "take",
module: "ActiveRecord::FinderMethods",
syntax: ".take(limit = nil)",
description: "Gives a record (or N records if a parameter is supplied) without any implied order. The order will depend on the database implementation. If an order is supplied it will be respected.",
example: "Person.take # returns an object fetched by SELECT * FROM people LIMIT 1
Person.take(5) # returns 5 objects fetched by SELECT * FROM people LIMIT 5
Person.where([\"name LIKE '%?'\", name]).take",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 104
def take(limit = nil)
  limit ? limit(limit).to_a : find_take
end"
  },
  {
name: "take!",
module: "ActiveRecord::FinderMethods",
syntax: ".take!()",
description: "Same as take but raises ActiveRecord::RecordNotFound if no record is found. Note that take! accepts no arguments.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 110
def take!
  take or raise RecordNotFound.new(\"Couldn't find #\{@klass.name} with [#\{arel.where_sql}]\")
end"
  },
  {
name: "third",
module: "ActiveRecord::FinderMethods",
syntax: ".third()",
description: "Find the third record. If no order is defined it will order by primary key.",
example: "Person.third # returns the third object fetched by SELECT * FROM people
Person.offset(3).third # returns the third object from OFFSET 3 (which is OFFSET 5)
Person.where([\"user_name = :u\", { u: user_name }]).third",
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 192
def third
  find_nth(2, offset_index)
end"
  },
  {
name: "third!",
module: "ActiveRecord::FinderMethods",
syntax: ".third!()",
description: "Same as third but raises ActiveRecord::RecordNotFound if no record is found.",
example: nil,
source: "# File activerecord/lib/active_record/relation/finder_methods.rb, line 198
def third!
  find_nth! 2
end"
  },
  {
name: "new",
module: "ActiveRecord::QueryMethods",
syntax: ".new(scope)",
description: nil,
example: nil,
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 14
def initialize(scope)
  @scope = scope
end"
  },
  {
name: "not",
module: "ActiveRecord::QueryMethods",
syntax: ".not(opts, *rest)",
description: "Returns a new relation expressing WHERE + NOT condition according to the conditions in the arguments.

not accepts conditions as a string, array, or hash. See where for more details on each format.",
example: "User.where.not(\"name = 'Jon'\")
# SELECT * FROM users WHERE NOT (name = 'Jon')

User.where.not([\"name = ?\", \"Jon\"])
# SELECT * FROM users WHERE NOT (name = 'Jon')

User.where.not(name: \"Jon\")
# SELECT * FROM users WHERE name != 'Jon'

User.where.not(name: nil)
# SELECT * FROM users WHERE name IS NOT NULL

User.where.not(name: %w(Ko1 Nobu))
# SELECT * FROM users WHERE name NOT IN ('Ko1', 'Nobu')

User.where.not(name: \"Jon\", role: \"admin\")
# SELECT * FROM users WHERE name != 'Jon' AND role != 'admin'",
source: "# File activerecord/lib/active_record/relation/query_methods.rb, line 41
def not(opts, *rest)
  where_value = @scope.send(:build_where, opts, rest).map do |rel|
    case rel
    when NilClass
      raise ArgumentError, 'Invalid argument for .where.not(), got nil.'
    when Arel::Nodes::In
      Arel::Nodes::NotIn.new(rel.left, rel.right)
    when Arel::Nodes::Equality
      Arel::Nodes::NotEqual.new(rel.left, rel.right)
    when String
      Arel::Nodes::Not.new(Arel::Nodes::SqlLiteral.new(rel))
    else
      Arel::Nodes::Not.new(rel)
    end
  end

  @scope.references!(PredicateBuilder.references(opts)) if Hash === opts
  @scope.where_values += where_value
  @scope
end"
  },
  {
name: "find_each",
module: "ActiveRecord::Batches",
syntax: ".find_each(options = {})",
description: "Looping through a collection of records from the database (using the all method, for example) is very inefficient since it will try to instantiate all the objects at once.

In that case, batch processing methods allow you to work with the records in batches, thereby greatly reducing memory consumption.

The find_each method uses find_in_batches with a batch size of 1000 (or as specified by the :batch_size option).",
example: "Person.find_each do |person|
  person.do_awesome_stuff
end

Person.where(\"age > 21\").find_each do |person|
  person.party_all_night!
end
If you do not provide a block to find_each, it will return an Enumerator for chaining with other methods:

Person.find_each.with_index do |person, index|
  person.award_trophy(index + 1)
end
Options

:batch_size - Specifies the size of the batch. Default to 1000.

:start - Specifies the starting point for the batch processing.

This is especially useful if you want multiple workers dealing with the same processing queue. You can make worker 1 handle all the records between id 0 and 10,000 and worker 2 handle from 10,000 and beyond (by setting the :start option on that worker).

# Let's process for a batch of 2000 records, skipping the first 2000 rows
Person.find_each(start: 2000, batch_size: 2000) do |person|
  person.party_all_night!
end
NOTE: It's not possible to set the order. That is automatically set to ascending on the primary key (\"id ASC\") to make the batch ordering work. This also means that this method only works with integer-based primary keys.

NOTE: You can't set the limit either, that's used to control the batch sizes.",
source: "# File activerecord/lib/active_record/relation/batches.rb, line 48
def find_each(options = {})
  if block_given?
    find_in_batches(options) do |records|
      records.each { |record| yield record }
    end
  else
    enum_for :find_each, options do
      options[:start] ? where(table[primary_key].gteq(options[:start])).size : size
    end
  end
end"
  },
  {
name: "find_in_batches",
module: "ActiveRecord::Batches",
syntax: ".find_in_batches(options = {})",
description: "Yields each batch of records that was found by the find options as an array.",
example: "Person.where(\"age > 21\").find_in_batches do |group|
  sleep(50) # Make sure it doesn't get too crowded in there!
  group.each { |person| person.party_all_night! }
end
If you do not provide a block to find_in_batches, it will return an Enumerator for chaining with other methods:

Person.find_in_batches.with_index do |group, batch|
  puts \"Processing group ##\{batch}\"
  group.each(&:recover_from_last_night!)
end
To be yielded each record one by one, use find_each instead.

Options

:batch_size - Specifies the size of the batch. Default to 1000.

:start - Specifies the starting point for the batch processing.

This is especially useful if you want multiple workers dealing with the same processing queue. You can make worker 1 handle all the records between id 0 and 10,000 and worker 2 handle from 10,000 and beyond (by setting the :start option on that worker).

# Let's process the next 2000 records
Person.find_in_batches(start: 2000, batch_size: 2000) do |group|
  group.each { |person| person.party_all_night! }
end
NOTE: It's not possible to set the order. That is automatically set to ascending on the primary key (\"id ASC\") to make the batch ordering work. This also means that this method only works with integer-based primary keys.

NOTE: You can't set the limit either, that's used to control the batch sizes.",
source: "# File activerecord/lib/active_record/relation/batches.rb, line 98
def find_in_batches(options = {})
  options.assert_valid_keys(:start, :batch_size)

  relation = self
  start = options[:start]
  batch_size = options[:batch_size] || 1000

  unless block_given?
    return to_enum(:find_in_batches, options) do
      total = start ? where(table[primary_key].gteq(start)).size : size
      (total - 1).div(batch_size) + 1
    end
  end

  if logger && (arel.orders.present? || arel.taken.present?)
    logger.warn(\"Scoped order and limit are ignored, it's forced to be batch order and batch size\")
  end

  relation = relation.reorder(batch_order).limit(batch_size)
  records = start ? relation.where(table[primary_key].gteq(start)).to_a : relation.to_a

  while records.any?
    records_size = records.size
    primary_key_offset = records.last.id
    raise \"Primary key not included in the custom select clause\" unless primary_key_offset

    yield records

    break if records_size < batch_size

    records = relation.where(table[primary_key].gt(primary_key_offset)).to_a
  end
end"
  },
  {
name: "all",
module: "ActiveRecord::Scoping::Named::ClassMethods",
syntax: ".all()",
description: "Returns an ActiveRecord::Relation scope object.",
example: "posts = Post.all
posts.size # Fires \"select count(*) from  posts\" and returns the count
posts.each {|p| puts p.name } # Fires \"select * from posts\" and loads post objects

fruits = Fruit.all
fruits = fruits.where(color: 'red') if options[:red_only]
fruits = fruits.limit(10) if limited?
You can define a scope that applies to all finders using ActiveRecord::Base.default_scope.",
source: "# File activerecord/lib/active_record/scoping/named.rb, line 24
def all
  if current_scope
    current_scope.clone
  else
    default_scoped
  end
end"
  },
  {
name: "scope",
module: "ActiveRecord::Scoping::Named::ClassMethods",
syntax: ".scope(name, body, &block)",
description: "Adds a class method for retrieving and querying objects. A scope represents a narrowing of a database query, such as where(color: :red).select('shirts.*').includes(:washing_instructions).",
example: "class Shirt < ActiveRecord::Base
  scope :red, -> { where(color: 'red') }
  scope :dry_clean_only, -> { joins(:washing_instructions).where('washing_instructions.dry_clean_only = ?', true) }
end
The above calls to scope define class methods Shirt.red and Shirt.dry_clean_only. Shirt.red, in effect, represents the query Shirt.where(color: 'red').

You should always pass a callable object to the scopes defined with scope. This ensures that the scope is re-evaluated each time it is called.

Note that this is simply 'syntactic sugar' for defining an actual class method:

class Shirt < ActiveRecord::Base
  def self.red
    where(color: 'red')
  end
end
Unlike Shirt.find(...), however, the object returned by Shirt.red is not an Array; it resembles the association object constructed by a has_many declaration. For instance, you can invoke Shirt.red.first, Shirt.red.count, Shirt.red.where(size: 'small'). Also, just as with the association objects, named scopes act like an Array, implementing Enumerable; Shirt.red.each(&block), Shirt.red.first, and Shirt.red.inject(memo, &block) all behave as if Shirt.red really was an Array.

These named scopes are composable. For instance, Shirt.red.dry_clean_only will produce all shirts that are both red and dry clean only. Nested finds and calculations also work with these compositions: Shirt.red.dry_clean_only.count returns the number of garments for which these criteria obtain. Similarly with Shirt.red.dry_clean_only.average(:thread_count).

All scopes are available as class methods on the ActiveRecord::Base descendant upon which the scopes were defined. But they are also available to has_many associations. If,

class Person < ActiveRecord::Base
  has_many :shirts
end
then elton.shirts.red.dry_clean_only will return all of Elton's red, dry clean only shirts.

Named scopes can also have extensions, just as with has_many declarations:

class Shirt < ActiveRecord::Base
  scope :red, -> { where(color: 'red') } do
    def dom_id
      'red_shirts'
    end
  end
end
Scopes can also be used while creating/building a record.

class Article < ActiveRecord::Base
  scope :published, -> { where(published: true) }
end

Article.published.new.published    # => true
Article.published.create.published # => true
Class methods on your model are automatically available on scopes. Assuming the following setup:

class Article < ActiveRecord::Base
  scope :published, -> { where(published: true) }
  scope :featured, -> { where(featured: true) }

  def self.latest_article
    order('published_at desc').first
  end

  def self.titles
    pluck(:title)
  end
end
We are able to call the methods like this:

Article.published.featured.latest_article
Article.featured.titles",
source: "# File activerecord/lib/active_record/scoping/named.rb, line 141
def scope(name, body, &block)
  unless body.respond_to?(:call)
    raise ArgumentError, 'The scope body needs to be callable.'
  end

  if dangerous_class_method?(name)
    raise ArgumentError, \"You tried to define a scope named \"#\{name}\" \"                \"on the model \"#\{self.name}\", but Active Record already defined \"                \"a class method with the same name.\"
  end

  extension = Module.new(&block) if block

  singleton_class.send(:define_method, name) do |*args|
    scope = all.scoping { body.call(*args) }
    scope = scope.extending(extension) if extension

    scope || all
  end
end"
  },
  {
name: "create",
module: "ActiveRecord::Persistence::ClassMethods",
syntax: ".create(attributes = nil, &block)",
description: "Creates an object (or multiple objects) and saves it to the database, if validations pass. The resulting object is returned whether the object was saved successfully to the database or not.

The attributes parameter can be either a Hash or an Array of Hashes. These Hashes describe the attributes on the objects that are to be created.",
example: "# Create a single new object
User.create(first_name: 'Jamie')

# Create an Array of new objects
User.create([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }])

# Create a single object and pass it into a block to set other attributes.
User.create(first_name: 'Jamie') do |u|
  u.is_admin = false
end

# Creating an Array of new objects using a block, where the block is executed for each object:
User.create([{ first_name: 'Jamie' }, { first_name: 'Jeremy' }]) do |u|
  u.is_admin = false
end",
source: "# File activerecord/lib/active_record/persistence.rb, line 29
def create(attributes = nil, &block)
  if attributes.is_a?(Array)
    attributes.collect { |attr| create(attr, &block) }
  else
    object = new(attributes, &block)
    object.save
    object
  end
end"
  },
  {
name: "create!",
module: "ActiveRecord::Persistence::ClassMethods",
syntax: ".create!(attributes = nil, &block)",
description: "Creates an object (or multiple objects) and saves it to the database, if validations pass. Raises a RecordInvalid error if validations fail, unlike Base#create.

The attributes parameter can be either a Hash or an Array of Hashes. These describe which attributes to be created on the object, or multiple objects when given an Array of Hashes.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 46
def create!(attributes = nil, &block)
  if attributes.is_a?(Array)
    attributes.collect { |attr| create!(attr, &block) }
  else
    object = new(attributes, &block)
    object.save!
    object
  end
end"
  },
  {
name: "instantiate",
module: "ActiveRecord::Persistence::ClassMethods",
syntax: ".instantiate(attributes, column_types = {})",
description: "Given an attributes hash, instantiate returns a new instance of the appropriate class. Accepts only keys as strings.

See +ActiveRecord::Inheritance#discriminate_class_for_record+ to see how this \"single-table\" inheritance mapping is implemented.",
example: "Post.all may return Comments, Messages, and Emails by storing the record's subclass in a type attribute. By calling instantiate instead of new, finder methods ensure they get new instances of the appropriate class for each record.",
source: "# File activerecord/lib/active_record/persistence.rb, line 66
def instantiate(attributes, column_types = {})
  klass = discriminate_class_for_record(attributes)
  attributes = klass.attributes_builder.build_from_database(attributes, column_types)
  klass.allocate.init_with('attributes' => attributes, 'new_record' => false)
end"
  },
  {
name: "becomes",
module: "ActiveRecord::Persistence",
syntax: ".becomes(klass)",
description: "Returns an instance of the specified klass with the attributes of the current record. This is mostly useful in relation to single-table inheritance structures where you want a subclass to appear as the superclass. This can be used along with record identification in Action Pack to allow, say, Client < Company to do something like render partial: @client.becomes(Company) to render that instance using the companies/company partial instead of clients/client.

Note: The new instance will share a link to the same attributes as the original class. So any change to the attributes in either instance will affect the other.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 198
def becomes(klass)
  became = klass.new
  became.instance_variable_set(\"@attributes\", @attributes)
  changed_attributes = @changed_attributes if defined?(@changed_attributes)
  became.instance_variable_set(\"@changed_attributes\", changed_attributes || {})
  became.instance_variable_set(\"@new_record\", new_record?)
  became.instance_variable_set(\"@destroyed\", destroyed?)
  became.instance_variable_set(\"@errors\", errors)
  became
end"
  },
  {
name: "becomes!",
module: "ActiveRecord::Persistence",
syntax: ".becomes!(klass)",
description: "Wrapper around becomes that also changes the instance's sti column value. This is especially useful if you want to persist the changed class in your database.

Note: The old instance's sti column value will be changed too, as both objects share the same set of attributes.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 215
def becomes!(klass)
  became = becomes(klass)
  sti_type = nil
  if !klass.descends_from_active_record?
    sti_type = klass.sti_name
  end
  became.public_send(\"#\{klass.inheritance_column}=\", sti_type)
  became
end"
  },
  {
name: "decrement",
module: "ActiveRecord::Persistence",
syntax: ".decrement(attribute, by = 1)",
description: "Initializes attribute to zero if nil and subtracts the value passed as by (default is 1). The decrement is performed directly on the underlying attribute, no setter is invoked. Only makes sense for number-based attributes. Returns self.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 328
def decrement(attribute, by = 1)
  self[attribute] ||= 0
  self[attribute] -= by
  self
end"
  },
  {
name: "decrement!",
module: "ActiveRecord::Persistence",
syntax: ".decrement!(attribute, by = 1)",
description: "Wrapper around decrement that saves the record. This method differs from its non-bang version in that it passes through the attribute setter. Saving is not subjected to validation checks. Returns true if the record could be saved.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 338
def decrement!(attribute, by = 1)
  decrement(attribute, by).update_attribute(attribute, self[attribute])
end"
  },
  {
name: "delete",
module: "ActiveRecord::Persistence",
syntax: ".delete()",
description: "Deletes the record in the database and freezes this instance to reflect that no changes should be made (since they can't be persisted). Returns the frozen instance.

The row is simply removed with an SQL DELETE statement on the record's primary key, and no callbacks are executed.

To enforce the object's before_destroy and after_destroy callbacks or any :dependent association options, use #destroy.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 155
def delete
  self.class.delete(id) if persisted?
  @destroyed = true
  freeze
end"
  },
  {
name: "destroy",
module: "ActiveRecord::Persistence",
syntax: ".destroy()",
description: "Deletes the record in the database and freezes this instance to reflect that no changes should be made (since they can't be persisted).

There's a series of callbacks associated with destroy!. If the before_destroy callback return false the action is cancelled and destroy! raises ActiveRecord::RecordNotDestroyed. See ActiveRecord::Callbacks for further details.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 184
def destroy!
  destroy || raise(RecordNotDestroyed.new(\"Failed to destroy the record\", self))
end"
  },
  {
name: "destroyed?",
module: "ActiveRecord::Persistence",
syntax: ".destroyed?()",
description: "Returns true if this object has been destroyed, otherwise returns false.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 91
def destroyed?
  sync_with_transaction_state
  @destroyed
end"
  },
  {
name: "increment",
module: "ActiveRecord::Persistence",
syntax: ".increment(attribute, by = 1)",
description: "Initializes attribute to zero if nil and adds the value passed as by (default is 1). The increment is performed directly on the underlying attribute, no setter is invoked. Only makes sense for number-based attributes. Returns self.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 311
def increment(attribute, by = 1)
  self[attribute] ||= 0
  self[attribute] += by
  self
end"
  },
  {
name: "increment!",
module: "ActiveRecord::Persistence",
syntax: ".increment!(attribute, by = 1)",
description: "Wrapper around increment that saves the record. This method differs from its non-bang version in that it passes through the attribute setter. Saving is not subjected to validation checks. Returns true if the record could be saved.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 321
def increment!(attribute, by = 1)
  increment(attribute, by).update_attribute(attribute, self[attribute])
end"
  },
  {
name: "new_record?",
module: "ActiveRecord::Persistence",
syntax: ".new_record?()",
description: "Returns true if this object hasn't been saved yet – that is, a record for the object doesn't exist in the database yet; otherwise, returns false.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 85
def new_record?
  sync_with_transaction_state
  @new_record
end"
  },
  {
name: "persisted?",
module: "ActiveRecord::Persistence",
syntax: ".persisted?()",
description: "Returns true if the record is persisted, i.e. it's not a new record and it was not destroyed, otherwise returns false.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 98
def persisted?
  !(new_record? || destroyed?)
end"
  },
  {
name: "reload",
module: "ActiveRecord::Persistence",
syntax: ".reload(options = nil)",
description: "Reloads the record from the database.

This method finds record by its primary key (which could be assigned manually) and modifies the receiver in-place.",
example: "account = Account.new
# => #<Account id: nil, email: nil>
account.id = 1
account.reload
# Account Load (1.2ms)  SELECT \"accounts\".* FROM \"accounts\" WHERE \"accounts\".\"id\" = $1 LIMIT 1  [[\"id\", 1]]
# => #<Account id: 1, email: 'account@example.com'>
Attributes are reloaded from the database, and caches busted, in particular the associations cache and the QueryCache.

If the record no longer exists in the database ActiveRecord::RecordNotFound is raised. Otherwise, in addition to the in-place modification the method returns self for convenience.

The optional :lock flag option allows you to lock the reloaded record:

reload(lock: true) # reload with pessimistic locking
Reloading is commonly used in test suites to test something is actually written to the database, or when some action modifies the corresponding row in the database but not the object in memory:

assert account.deposit!(25)
assert_equal 25, account.credit        # check it is updated in memory
assert_equal 25, account.reload.credit # check it is also persisted
Another common use case is optimistic locking handling:

def with_optimistic_retry
  begin
    yield
  rescue ActiveRecord::StaleObjectError
    begin
      # Reload lock_version in particular.
      reload
    rescue ActiveRecord::RecordNotFound
      # If the record is gone there is nothing to do.
    else
      retry
    end
  end
end",
source: "# File activerecord/lib/active_record/persistence.rb, line 407
def reload(options = nil)
  clear_aggregation_cache
  clear_association_cache
  self.class.connection.clear_query_cache

  fresh_object =
    if options && options[:lock]
      self.class.unscoped { self.class.lock(options[:lock]).find(id) }
    else
      self.class.unscoped { self.class.find(id) }
    end

  @attributes = fresh_object.instance_variable_get('@attributes')
  @new_record = false
  self
end"
  },
  {
name: "save",
module: "ActiveRecord::Persistence",
syntax: ".save(*)",
description: "Saves the model.

If the model is new a record gets created in the database, otherwise the existing record gets updated.

By default, save always run validations. If any of them fail the action is cancelled and save returns false. However, if you supply validate: false, validations are bypassed altogether. See ActiveRecord::Validations for more information.

There's a series of callbacks associated with save. If any of the before_* callbacks return false the action is cancelled and save returns false. See ActiveRecord::Callbacks for further details.

Attributes marked as readonly are silently ignored if the record is being updated.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 119
def save(*)
  create_or_update
rescue ActiveRecord::RecordInvalid
  false
end"
  },
  {
name: "save!",
module: "ActiveRecord::Persistence",
syntax: ".save!(*)",
description: "Saves the model.

If the model is new a record gets created in the database, otherwise the existing record gets updated.

With save! validations always run. If any of them fail ActiveRecord::RecordInvalid gets raised. See ActiveRecord::Validations for more information.

There's a series of callbacks associated with save!. If any of the before_* callbacks return false the action is cancelled and save! raises ActiveRecord::RecordNotSaved. See ActiveRecord::Callbacks for further details.

Attributes marked as readonly are silently ignored if the record is being updated.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 141
def save!(*)
  create_or_update || raise(RecordNotSaved.new(\"Failed to save the record\", self))
end"
  },
  {
name: "toggle",
module: "ActiveRecord::Persistence",
syntax: ".toggle(attribute)",
description: "Assigns to attribute the boolean opposite of attribute?. So if the predicate returns true the attribute will become false. This method toggles directly the underlying value without calling any setter. Returns self.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 346
def toggle(attribute)
  self[attribute] = !send(\"#\{attribute}?\")
  self
end"
  },
  {
name: "toggle!",
module: "ActiveRecord::Persistence",
syntax: ".toggle!(attribute)",
description: "Wrapper around toggle that saves the record. This method differs from its non-bang version in that it passes through the attribute setter. Saving is not subjected to validation checks. Returns true if the record could be saved.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 355
def toggle!(attribute)
  toggle(attribute).update_attribute(attribute, self[attribute])
end"
  },
  {
name: "touch",
module: "ActiveRecord::Persistence",
syntax: ".touch(*names)",
description: "Saves the record with the updated_at/on attributes set to the current time. Please note that no validation is performed and only the after_touch, after_commit and after_rollback callbacks are executed.",
example: "If attribute names are passed, they are updated along with updated_at/on attributes.

product.touch                         # updates updated_at/on
product.touch(:designed_at)           # updates the designed_at attribute and updated_at/on
product.touch(:started_at, :ended_at) # updates started_at, ended_at and updated_at/on attributes
If used along with belongs_to then touch will invoke touch method on associated object.

class Brake < ActiveRecord::Base
  belongs_to :car, touch: true
end

class Car < ActiveRecord::Base
  belongs_to :corporation, touch: true
end

# triggers @brake.car.touch and @brake.car.corporation.touch
@brake.touch
Note that touch must be used on a persisted object, or else an ActiveRecordError will be thrown. For example:

ball = Ball.new
ball.touch(:updated_at)   # => raises ActiveRecordError",
source: "# File activerecord/lib/active_record/persistence.rb, line 455
def touch(*names)
  raise ActiveRecordError, \"cannot touch on a new record object\" unless persisted?

  attributes = timestamp_attributes_for_update_in_model
  attributes.concat(names)

  unless attributes.empty?
    current_time = current_time_from_proper_timezone
    changes = {}

    attributes.each do |column|
      column = column.to_s
      changes[column] = write_attribute(column, current_time)
    end

    changes[self.class.locking_column] = increment_lock if locking_enabled?

    clear_attribute_changes(changes.keys)
    primary_key = self.class.primary_key
    self.class.unscoped.where(primary_key => self[primary_key]).update_all(changes) == 1
  else
    true
  end
end"
  },
  {
name: "update",
module: "ActiveRecord::Persistence",
syntax: ".update(attributes)",
description: "Updates the attributes of the model from the passed-in hash and saves the record, all wrapped in a transaction. If the object is invalid, the saving will fail and false will be returned.

Also aliased as: update_attributes.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 247
def update(attributes)
  # The following transaction covers any possible database side-effects of the
  # attributes assignment. For example, setting the IDs of a child collection.
  with_transaction_returning_status do
    assign_attributes(attributes)
    save
  end
end"
  },
  {
name: "update!",
module: "ActiveRecord::Persistence",
syntax: ".update!(attributes)",
description: "Updates its receiver just like update but calls save! instead of save, so an exception is raised if the record is invalid.

Also aliased as: update_attributes!.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 260
def update!(attributes)
  # The following transaction covers any possible database side-effects of the
  # attributes assignment. For example, setting the IDs of a child collection.
  with_transaction_returning_status do
    assign_attributes(attributes)
    save!
  end
end"
  },
  {
name: "update_attribute",
module: "ActiveRecord::Persistence",
syntax: ".update_attribute(name, value)",
description: "Updates a single attribute and saves the record. This is especially useful for boolean flags on existing records. Also note that

Validation is skipped.

Callbacks are invoked.

updated_at/updated_on column is updated if that column is available.

Updates all the attributes that are dirty in this object.

This method raises an ActiveRecord::ActiveRecordError if the attribute is marked as readonly.

See also update_column.",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 237
def update_attribute(name, value)
  name = name.to_s
  verify_readonly_attribute(name)
  send(\"#\{name}=\", value)
  save(validate: false)
end"
  },
  {
name: "update_attributes",
module: "ActiveRecord::Persistence",
syntax: ".update_attributes(attributes)",
description: "Alias for: update.",
example: nil,
source: nil
  },
  {
name: "update_attributes!",
module: "ActiveRecord::Persistence",
syntax: ".update_attributes!(attributes)",
description: "Alias for: update!.",
example: nil,
source: nil
  },
  {
name: "update_column",
module: "ActiveRecord::Persistence",
syntax: ".update_column(name, value)",
description: "Equivalent to update_columns(name => value).",
example: nil,
source: "# File activerecord/lib/active_record/persistence.rb, line 272
def update_column(name, value)
  update_columns(name => value)
end"
  },
  {
name: "update_columns",
module: "ActiveRecord::Persistence",
syntax: ".update_columns(attributes)",
description: "Updates the attributes directly in the database issuing an UPDATE SQL statement and sets them in the receiver.

This is the fastest way to update attributes because it goes straight to the database, but take into account that in consequence the regular update procedures are totally bypassed. In particular:

Validations are skipped.

Callbacks are skipped.

updated_at/updated_on are not updated.

This method raises an ActiveRecord::ActiveRecordError when called on new objects, or when at least one of the attributes is marked as readonly.",
example: "user.update_columns(last_request_at: Time.current)",
source: "# File activerecord/lib/active_record/persistence.rb, line 291
def update_columns(attributes)
  raise ActiveRecordError, \"cannot update a new record\" if new_record?
  raise ActiveRecordError, \"cannot update a destroyed record\" if destroyed?

  attributes.each_key do |key|
    verify_readonly_attribute(key.to_s)
  end

  updated_count = self.class.unscoped.where(self.class.primary_key => id).update_all(attributes)

  attributes.each do |k, v|
    raw_write_attribute(k, v)
  end

  updated_count == 1
end"
  },
  {
name: "average",
module: "ActiveRecord::Calculations",
syntax: ".average(column_name, options = {})",
description: "Calculates the average value on a given column. Returns nil if there's no row. See calculate for examples with options.",
example: "Person.average(:age) # => 35.8",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 49
def average(column_name, options = {})
  # TODO: Remove options argument as soon we remove support to
  # activerecord-deprecated_finders.
  calculate(:average, column_name, options)
end"
  },
  {
name: "calculate",
module: "ActiveRecord::Calculations",
syntax: ".calculate(operation, column_name, options = {})",
description: "This calculates aggregate values in the given column. Methods for count, sum, average, minimum, and maximum have been added as shortcuts.",
example: "There are two basic forms of output:

* Single aggregate value: The single value is type cast to Fixnum for COUNT, Float
  for AVG, and the given column's type for everything else.

* Grouped values: This returns an ordered hash of the values and groups them. It
  takes either a column name, or the name of a belongs_to association.

    values = Person.group('last_name').maximum(:age)
    puts values[\"Drake\"]
    # => 43

    drake  = Family.find_by(last_name: 'Drake')
    values = Person.group(:family).maximum(:age) # Person belongs_to :family
    puts values[drake]
    # => 43

    values.each do |family, max_age|
    ...
    end

Person.calculate(:count, :all) # The same as Person.count
Person.average(:age) # SELECT AVG(age) FROM people...

# Selects the minimum age for any family without any minors
Person.group(:last_name).having(\"min(age) > 17\").minimum(:age)

Person.sum(\"2 * age\")",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 117
def calculate(operation, column_name, options = {})
  # TODO: Remove options argument as soon we remove support to
  # activerecord-deprecated_finders.
  if column_name.is_a?(Symbol) && attribute_alias?(column_name)
    column_name = attribute_alias(column_name)
  end

  if has_include?(column_name)
    construct_relation_for_association_calculations.calculate(operation, column_name, options)
  else
    perform_calculation(operation, column_name, options)
  end
end"
  },
  {
name: "count",
module: "ActiveRecord::Calculations",
syntax: ".count(column_name = nil, options = {})",
description: "Count the records.",
example: "Person.count
# => the total count of all people

Person.count(:age)
# => returns the total count of all people whose age is present in database

Person.count(:all)
# => performs a COUNT(*) (:all is an alias for '*')

Person.distinct.count(:age)
# => counts the number of different age values
If count is used with group, it returns a Hash whose keys represent the aggregated column, and the values are the respective amounts:

Person.group(:city).count
# => { 'Rome' => 5, 'Paris' => 3 }
If count is used with group for multiple columns, it returns a Hash whose keys are an array containing the individual values of each column and the value of each key would be the count.

Article.group(:status, :category).count
# =>  {[\"draft\", \"business\"]=>10, [\"draft\", \"technology\"]=>4,
       [\"published\", \"business\"]=>0, [\"published\", \"technology\"]=>2}
If count is used with select, it will count the selected columns:

Person.select(:age).count
# => counts the number of different age values
Note: not all valid select expressions are valid count expressions. The specifics differ between databases. In invalid cases, an error from the database is thrown.",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 38
def count(column_name = nil, options = {})
  # TODO: Remove options argument as soon we remove support to
  # activerecord-deprecated_finders.
  column_name, options = nil, column_name if column_name.is_a?(Hash)
  calculate(:count, column_name, options)
end"
  },
  {
name: "ids",
module: "ActiveRecord::Calculations",
syntax: ".ids()",
description: "Pluck all the ID's for the relation using the table's primary key.",
example: "Person.ids # SELECT people.id FROM people
Person.joins(:companies).ids # SELECT people.id FROM people INNER JOIN companies ON companies.person_id = people.id
",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 189
def ids
  pluck primary_key
end"
  },
  {
name: "maximum",
module: "ActiveRecord::Calculations",
syntax: ".maximum(column_name, options = {})",
description: "Calculates the maximum value on a given column. The value is returned with the same data type of the column, or nil if there's no row. See calculate for examples with options.",
example: "Person.maximum(:age) # => 93",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 71
def maximum(column_name, options = {})
  # TODO: Remove options argument as soon we remove support to
  # activerecord-deprecated_finders.
  calculate(:maximum, column_name, options)
end"
  },
  {
name: "minimum",
module: "ActiveRecord::Calculations",
syntax: ".minimum(column_name, options = {})",
description: "Calculates the minimum value on a given column. The value is returned with the same data type of the column, or nil if there's no row. See calculate for examples with options.",
example: "Person.minimum(:age) # => 7",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 60
def minimum(column_name, options = {})
  # TODO: Remove options argument as soon we remove support to
  # activerecord-deprecated_finders.
  calculate(:minimum, column_name, options)
end"
  },
  {
name: "pluck",
module: "ActiveRecord::Calculations",
syntax: ".pluck(*column_names)",
description: "Use pluck as a shortcut to select one or more attributes without loading a bunch of records just to grab the attributes you want.

Person.pluck(:name)
instead of

Person.all.map(&:name)
Pluck returns an Array of attribute values type-casted to match the plucked column names, if they can be deduced. Plucking an SQL fragment returns String values by default.",
example: "Person.pluck(:id)
# SELECT people.id FROM people
# => [1, 2, 3]

Person.pluck(:id, :name)
# SELECT people.id, people.name FROM people
# => [[1, 'David'], [2, 'Jeremy'], [3, 'Jose']]

Person.pluck('DISTINCT role')
# SELECT DISTINCT role FROM people
# => ['admin', 'member', 'guest']

Person.where(age: 21).limit(5).pluck(:id)
# SELECT people.id FROM people WHERE people.age = 21 LIMIT 5
# => [2, 3]

Person.pluck('DATEDIFF(updated_at, created_at)')
# SELECT DATEDIFF(updated_at, created_at) FROM people
# => ['0', '27761', '173']",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 164
def pluck(*column_names)
  column_names.map! do |column_name|
    if column_name.is_a?(Symbol) && attribute_alias?(column_name)
      attribute_alias(column_name)
    else
      column_name.to_s
    end
  end

  if has_include?(column_names.first)
    construct_relation_for_association_calculations.pluck(*column_names)
  else
    relation = spawn
    relation.select_values = column_names.map { |cn|
      columns_hash.key?(cn) ? arel_table[cn] : cn
    }
    result = klass.connection.select_all(relation.arel, nil, relation.arel.bind_values + bind_values)
    result.cast_values(klass.column_types)
  end
end"
  },
  {
name: "sum",
module: "ActiveRecord::Calculations",
syntax: ".sum(*args)",
description: "Calculates the sum of values on a given column. The value is returned with the same data type of the column, 0 if there's no row. See calculate for examples with options.",
example: "Person.sum(:age) # => 4562",
source: "# File activerecord/lib/active_record/relation/calculations.rb, line 82
def sum(*args)
  calculate(:sum, *args)
end"
  },
  {
name: "find_by_sql",
module: "ActiveRecord::Querying",
syntax: ".find_by_sql(sql, binds = [])",
description: "Executes a custom SQL query against your database and returns all the results. The results will be returned as an array with columns requested encapsulated as attributes of the model you call this method from. If you call Product.find_by_sql then the results will be returned in a Product object with the attributes you specified in the SQL query.

If you call a complicated SQL query which spans multiple tables the columns specified by the SELECT will be attributes of the model, whether or not they are columns of the corresponding table.

The sql parameter is a full SQL query as a string. It will be called as is, there will be no database agnostic conversions performed. This should be a last resort because using, for example, MySQL specific terms will lock you to using that particular database engine or require you to change your call if you switch engines.",
example: "# A simple SQL query spanning multiple tables
Post.find_by_sql \"SELECT p.title, c.author FROM posts p, comments c WHERE p.id = c.post_id\"
# => [#<Post:0x36bff9c @attributes={\"title\"=>\"Ruby Meetup\", \"first_name\"=>\"Quentin\"}>, ...]
You can use the same string replacement techniques as you can with ActiveRecord::QueryMethods#where:

Post.find_by_sql [\"SELECT title FROM posts WHERE author = ? AND created > ?\", author_id, start_date]
Post.find_by_sql [\"SELECT body FROM comments WHERE author = :user_id OR approved_by = :user_id\", { :user_id => user_id }]",
source: "# File activerecord/lib/active_record/querying.rb, line 38
def find_by_sql(sql, binds = [])
  result_set = connection.select_all(sanitize_sql(sql), \"#\{name} Load\", binds)
  column_types = {}

  if result_set.respond_to? :column_types
    column_types = result_set.column_types
  else
    ActiveSupport::Deprecation.warn \"the object returned from `select_all` must respond to `column_types`\"
  end

  result_set.map { |record| instantiate(record, column_types) }
end"
  },
  {
name: "count_by_sql",
module: "ActiveRecord::Querying",
syntax: ".count_by_sql(sql)",
description: "Returns the result of an SQL statement that should only include a COUNT(*) in the SELECT part. The use of this method should be restricted to complicated SQL queries that can't be executed using the ActiveRecord::Calculations class methods. Look into those before using this.

Parameters

sql - An SQL statement which should return a count query from the database, see the example below.

Product.count_by_sql \"SELECT COUNT(*) FROM sales s, customers c WHERE s.customer_id = c.id\"",
example: nil,
source: "# File activerecord/lib/active_record/querying.rb, line 60
def count_by_sql(sql)
  sql = sanitize_conditions(sql)
  connection.select_value(sql, \"#\{name} Count\").to_i
end"
  }
]

all_methods.each { |meth_params| ActRecMethod.create(meth_params) }

env_descrip =
"""
This problem set involves the ActiveRecord model |~ActRecMethod|.

The corresponding database table |@act_rec_models| is seeded with documenatation on public instance methods
from the ActiveRecord module that may come in handy when contructing and interacting
with the database of an app powered by |%Ruby| on Rails.
"""
stupid_sexy_queries = Environment.create(
  title: "feels |?LIKE| i'm |#find|ing nothing at |#all|!",
  description: env_descrip[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
  models: { "ActRecMethod"=>"act_rec_method.rb" }.to_json)

prob_instruct =
"""
The bread and butter of any Rails controller's 'show' page action, this ActiveRecord method can be used to |#find|
records by their primary |*key| provided its |`value| is an |`integer|. Speaking of primary |*key|s, this method is stored
as an |~ActRecMethod| object in |@act_rec_models| with an |*id| of |`28|.

Complete the |%solution| method so that it returns the ActiveRecord |~ActRecMethod| object representing the
ActiveRecord method described above.
"""
def answer_babys_first
  ActRecMethod.find(28)
end
babys_first = stupid_sexy_queries.problems.create(
  title: "baby's |#first| query",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
  answer: Array.wrap(answer_babys_first).to_json)

prob_instruct =
"""
The methods included in the |@act_rec_methods| table are taken from the following 8 ActiveRecord modules:

|`ActiveRecord::QueryMethods|^
|`ActiveRecord::Persistence|^
|`ActiveRecord::FinderMethods|^
|`ActiveRecord::Persistence::ClassMethods|^
|`ActiveRecord::Batches|^
|`ActiveRecord::Scoping::Named::ClassMethods|^
|`ActiveRecord::Calculations|^
|`ActiveRecord::Querying|^

How many methods belong to each |*module|?

Complete the |%solution| method so that it returns a key-value hash representing
the |#count| of methods belonging to each |*module| in the following format:

|%{ \"||*module0||%\"=>| |`num_methods7||%, ..., \"||*module7||%\"=>| |`num_methods7| |%}|
"""
def answer_count_modulea
  ActRecMethod.group(:module).count
end
count_modulea = stupid_sexy_queries.problems.create(
  title: "|#count| |*module|a",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n").gsub(/\^/,"\n"),
  answer: Array.wrap(answer_count_modulea).to_json)

prob_instruct =
"""
If you haven't noticed, some of the documentation for these methods are missing an |*example|,
the |*source| code, or even a |*description|. These uninitialized |*attribute|s are assigned the
|`value| |`nil| upon their record's |#create|ion as per the ActiveRecord default.

Complete the |%solution| method so that it returns an array of ActiveRecord |~ActRecMethod| objects representing |#all|
ActiveRecord methods with a provided |*example|, |*source| code, |?AND| |*description| in their documentation
(i.e. |~ActRecMethod|s |#where| the |`value|s of |*example|, |*source|, |?AND| |*description| are |#not| |`nil|).
Please return your |%solution| |#order|ed by |*id| (default for un|#order|ed queries).
"""
def answer_nothing_at_all
  ActRecMethod.where.not({ example: nil, source: nil, description: nil })
end
nothing_at_all = stupid_sexy_queries.problems.create(
  title: "|#not|hing at |#all|!, |?NOT|hing at |?*|!...",
  instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
  answer: Array.wrap(answer_nothing_at_all).to_json)

# g0_yobs = (1880..1890).to_a
# genders = ["M", "F"]

# 30.times do
#   g0_yob = g0_yobs.sample
#   g0_gender = genders.sample
#   g0_baby_name = BabyName.where("yob = #{g0_yob} AND gender = '#{g0_gender}'").sample
#   g0_name = g0_baby_name.name
#   g0_frequency = g0_baby_name.frequency

#   g0_spouse_yob = g0_yobs.sample
#   g0_spouse_gender = genders.reject { |gender| gender == g0_gender }.first
#   g0_baby_name = BabyName.where("yob = #{g0_spouse_yob} AND gender = '#{g0_spouse_gender}'").sample
#   g0_spouse_name = g0_baby_name.name
#   g0_spouse_frequency = g0_baby_name.frequency

#   g0 = Person.create(name: g0_name,
#                    gender: g0_gender,
#                       yob: g0_yob,
#                 frequency: g0_frequency)
#   g0_spouse = Person.create(name: g0_spouse_name,
#                           gender: g0_spouse_gender,
#                              yob: g0_spouse_yob,
#                        frequency: g0_spouse_frequency)

#   g0.update(spouse_id: g0_spouse.id)
#   g0_spouse.update(spouse_id: g0.id)

#   mother, father = g0.gender == "M" ? [g0_spouse, g0] : [g0, g0_spouse]

#   rand(8).times do
#     g1_gender = genders.sample
#     g1_yob = (g0_yob + g0_spouse_yob) / 2 + rand(20..35)
#     g1_baby_name = BabyName.where("yob = #{g1_yob} AND gender = '#{g1_gender}'").sample
#     g1_name = g1_baby_name.name
#     g1_frequency = g1_baby_name.frequency
#     Person.create(name: g1_name,
#                gender: g1_gender,
#                   yob: g1_yob,
#             frequency: g1_frequency,
#             mother_id: mother.id,
#             father_id: mother.spouse.id)
#   end
# end

# remaining_generations = [1, 2, 3, 4]

# remaining_generations.each do |gen|
#   gx_bachelors_ettes = Person.where(spouse_id: nil).where(generation: gen)
#   if gen == 3
#     dad_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").first
#     dad_grandmother = dad_grandfather.spouse
#     mom_grandfather = Person.where.not(spouse_id: nil).where(generation: 1).where(gender: "M").last
#     mom_grandmother = mom_grandfather.spouse

#     dad_baby_name = BabyName.find_by({ name: "Mike", gender: "M", yob: 1932 })
#     dad_frequency = dad_baby_name.frequency
#     mom_baby_name = BabyName.find_by({ name: "Carol", gender: "F", yob: 1934 })
#     mom_frequency = mom_baby_name.frequency

#     dad = { name: "Mike", gender: "M", yob: 1932, frequency: dad_frequency, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
#     mom = { name: "Carol", gender: "F", yob: 1934, frequency: mom_frequency, mother_id: mom_grandmother.id, father_id: mom_grandfather.id }
#     father = Person.create(dad)
#     mother = Person.create(mom)

#     father.update(spouse_id: mother.id)
#     mother.update(spouse_id: father.id)

#     kids = [{ name: "Greg", gender: "M", yob: 1954 },
#             { name: "Marcia", gender: "F", yob: 1956 },
#             { name: "Peter", gender: "M", yob: 1957 },
#             { name: "Jan", gender: "F", yob: 1958 },
#             { name: "Bobby", gender: "M", yob: 1960 },
#             { name: "Cindy", gender: "F", yob: 1961 }]
#     kids.each do |kid|
#       kid[:frequency] = BabyName.find_by(kid).frequency
#       kid[:mother_id] = mother.id
#       kid[:father_id] = father.id
#       child = Person.create(kid)
#     end

#     gx_bachelors = Person.where(spouse_id: nil).where(generation: gen).where(gender: "M");
#     gx_bachelorettes = Person.where(spouse_id: nil).where(generation: gen).where(gender: "F");

#     if gx_bachelors.count == gx_bachelorettes.count
#       mother = Person.where.not(spouse_id: nil).where(generation: gen - 1).where(gender: "F")
#       b_gender = genders.sample
#       b_yob = (mother.yob + father.yob) / 2 + rand(20..35)
#       b_yob = b_yob > 2014 ? 2014 : b_yob
#       b_baby_name = BabyName.where("yob = #{b_yob} AND gender = '#{b_gender}'").sample
#       b_name = b_baby_name.name
#       b_frequency = b_baby_name.frequency
#       the_bachelor_ette = Person.create(name: b_name,
#                                       gender: b_gender,
#                                          yob: b_yob,
#                                    frequency: b_frequency,
#                                    mother_id: mother.id,
#                                    father_id: mother.spouse.id)
#     elsif gx_bachelors.count > gx_bachelorettes.count
#       the_bachelor_ette = gx_bachelorettes.sample
#     else
#       the_bachelor_ette = gx_bachelors.sample
#     end

#     gx_bachelors_ettes = Person.where(spouse_id: nil).where(generation: gen).where.not(id: the_bachelor_ette.id)
#   end



#   gx_bachelors_ettes.each do |gx|
#     valid_spouses = gx_bachelors_ettes.where(spouse_id: nil).where.not(mother_id: gx.mother_id).where.not(gender: gx.gender).where(generation: gen)
#     break if valid_spouses.count == 0
#     gx_spouse = valid_spouses.take
#     gx.update(spouse_id: gx_spouse.id)
#     gx_spouse.update(spouse_id: gx.id)

#     unless gen == 4
#       mother, father = gx.gender == "M" ? [gx_spouse, gx] : [gx, gx_spouse]
#       rand(8).times do
#         gy_gender = genders.sample
#         gy_yob = (mother.yob + father.yob) / 2 + rand(20..35)
#         gy_yob = gy_yob > 2014 ? 2014 : gy_yob
#         gy_baby_name = BabyName.where("yob = #{gy_yob} AND gender = '#{gy_gender}'").sample
#         gy_name = gy_baby_name.name
#         gy_frequency = gy_baby_name.frequency
#         Person.create(name: gy_name,
#                     gender: gy_gender,
#                        yob: gy_yob,
#                  frequency: gy_frequency,
#                  mother_id: mother.id,
#                  father_id: mother.spouse.id)
#       end
#     end
#   end
# end

# env_descrip =
# """
# This problem set involves the ActiveRecord models |~BabyName| and |~Person|.

# The corresponding database table |@baby_names| is seeded with data recorded from
# 1880 to 2014 on baby names with over 5 occurences in the US.

# The second table |@people| is seeded with several interwoven families
# spanning up to 5 |*generation|s of |~Person|s born between 1880 and 2014.

# All of the problems in this set can be solved by querying just the |@people| table.
# """
# family_tree = Environment.create(
#   title: "the |@people| family tree",
#   description: env_descrip[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   models: { "Person"=>"person.rb", "BabyName"=>"baby_name.rb" }.to_json)

# prob_instruct =
# """
# |~Person|s of the |@people| table may have 0 or more |&children| as per the ActiveRecord |#has_many|
# association. Assuming your typical American household houses 1.5 |&children|, and our database
# refrains from tracking pregnancies and the heights of its tenants, let us define a typical household
# of |~Person|s as one having either 1 |?OR| 2 |&children|.

# Complete the |%solution| method so that it returns an array of ActiveRecord |~Person| objects
# representing the |&mother|s and |&father|s of a typical household, |#order|ed alphabetically by |*name|.

# Note that |&children| is a custom method (see person.rb in the inspector) and not a pure ActiveRecord relation.
# This method allows for |&mother|s and |&father|s to access the same ActiveRecord collection of |&children| without having to create an additional join table,
# but at the cost of making 2 additional queries for every call.
# """
# def answer_avg_household
#   Person.where(children_count: [1, 2]).order(:name)
# end
# avg_household = family_tree.problems.create(
#   title: "...and here are our |`1.5| kids",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_avg_household).to_json)

# prob_instruct =
# """
# ~♪ Here's the story, of a lovely lady... ♪~

# Hidden within the |@people| table is a |&mother|, a |&father|, and 6 |&children|
# having |*name|s of the Brady Bunch and |*yob|s corresponding to the years of birth
# of the actors who played their roles.

# Complete the |%solution| method so that it returns an array of ActiveRecord |~Person| objects
# representing the Brady Bunch that is |#order|ed from youngest to oldest.
# """
# def answer_brady_bunch
#   mike_brady = Person.find_by({name: "Mike", children_count: 6, yob: 1932})
#   carol_brady = mike_brady.spouse
#   brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child| brady_child }
#   if mike_brady.yob > carol_brady.yob
#     brady_bunch << mike_brady << carol_brady
#   else
#     brady_bunch << carol_brady << mike_brady
#   end
#   brady_bunch
# end
# the_brady_bunch = family_tree.problems.create(
#   title: "the Brady Bunch",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_brady_bunch).to_json)

# prob_instruct =
# """
# Within the |@people| family tree, all |~Person|s were able to find a non-sibling |&spouse|
# of the opposite gender who was also born in their |*generation|. In other words, all within
# a |*generation| were married off two by two until a lonely pool of |`\"M\"|s or |`\"F\"|s remained. All,
# that is, except for one lucky individual.

# Complete the |%solution| method so that it returns the ActiveRecord |~Person| object representing the Bachelor(ette).
# """
# def answer_bachelor
#   all_singles = Person.where(spouse_id: nil)
#   gens_with_singles = all_singles.pluck(:generation).uniq
#   gens_with_singles.each do |gen|
#     genders_of_singles = all_singles.where(generation: gen).pluck(:gender)
#     m_and_f_available = genders_of_singles.uniq.size == 2 ? true : false
#     if m_and_f_available
#       if genders_of_singles.count("F") > 1
#         the_bachelor = all_singles.find_by({ generation: gen, gender: "M" })
#         return the_bachelor
#       else
#         the_bachelorette = all_singles.find_by({ generation: gen, gender: "F" })
#         return the_bachelorette
#       end
#     end
#   end
#   return "no bachelor(ette)s!"
# end
# the_bachelor = family_tree.problems.create(
#   title: "the Bachelor(ette?)",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_bachelor).to_json)

# prob_instruct =
# """
# Every |~Person| was |*name|d by their |&mother| and |&father| corresponding to a |~BabyName| of the same |*yob|.
# Accordingly, for every |~Person|, |~person_example|, born in the year |`person_example.yob|, there were

# |~BabyName||#.find_by({| |*name:| |`person_example.name||#,| |*gender:| |`person_example.gender||#,| |*yob:| |`person_example.yob| |#})||*.frequency| |- 1|

# other |~Person|s born in the States that year sharing the same |*name|. To save you some time and to
# spare our servers the cost of querying a 1825433-entry table thousands of times, the |*frequency| of a |~Person|s
# |*name| for their |*gender| and |*yob| has been cached as:

# |~person_example||*.frequency|

# when |@people| was seeded. The Laziest Parents Award will go to the
# |&mother| and |&father| of the |~Person| born with the most common |*name| for their |*generation|.

# Complete the |%solution| method so that it returns an 8 element array of ActiveRecord |~Person| objects
# representing the laziest parents of each |*generation|, |#order|ed by generation in the following format:

# |%[gen0_lazy_mother, gen0_lazy_father, ..., ..., gen3_lazy_mother, gen3_lazy_father]|
# """
# def answer_lazy_parents
#   children_gens = [1, 2, 3, 4]
#   laziest_parents = children_gens.map do |gen|
#     max_freq_child = Person.where(generation: gen).order(frequency: :desc).take
#     [max_freq_child.mother, max_freq_child.father]
#   end
#   laziest_parents.flatten
# end
# lazy_parents_award = family_tree.problems.create(
#   title: "the laziest parents award",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_lazy_parents).to_json)


# crops = {
#   "barley"=> {
#     "price"=> 5.62/40,
#     "yield"=> 71.3*40
#   },
#   "beans"=> {
#     "price"=> 35.8/100,
#     "yield"=> 1753.0
#   },
#   "corn"=> {
#     "price"=> 4.11/56,
#     "yield"=> 171*56
#   },
#   "cotton"=> {
#     "price"=> 0.80,
#     "yield"=> 838.0
#   },
#   "flaxseed"=> {
#     "price"=> 13.2/56,
#     "yield"=> 21.1*56
#   },
#   "hay"=> {
#     "price"=> 178.0/2000,
#     "yield"=> 2.45*2000
#   },
#   "hops"=> {
#     "price"=> 1.83,
#     "yield"=> 1868.0
#   },
#   "lentils"=> {
#     "price"=> 21.1/100,
#     "yield"=> 1300.0
#   },
#   "oats"=> {
#     "price"=> 3.54/60,
#     "yield"=> 68.6*60
#   },
#   "peanuts"=> {
#     "price"=> 0.23,
#     "yield"=> 3932.0
#   },
#   "rice"=> {
#     "price"=> 15.6/100,
#     "yield"=> 7572.0
#   },
#   "grain"=> {
#     "price"=> 7.41/100,
#     "yield"=> 67.6*56
#   },
#   "soybeans"=> {
#     "price"=> 12.5/60,
#     "yield"=> 47.8*60
#   },
#   "sunflower"=> {
#     "price"=> 21.7/100,
#     "yield"=> 1469.0
#   },
#   "wheat"=> {
#     "price"=> 6.34/100,
#     "yield"=> 44.3*100
#   },
#   "artichokes"=> {
#     "price"=> 50.4/100,
#     "yield"=> 130.0*100
#   },
#   "asparagus"=> {
#     "price"=> 111.0/100,
#     "yield"=> 31.0*100
#   },
#   "beets"=> {
#     "price"=> 65.8/100,
#     "yield"=> 16.72*2000
#   },
#   "broccoli"=> {
#     "price"=> 35.1/100,
#     "yield"=> 147.0*100
#   },
#   "brussel sprouts"=> {
#     "price"=> 36.5/100,
#     "yield"=> 180.0*100
#   },
#   "cabbage"=> {
#     "price"=> 17.7/100,
#     "yield"=> 357.0*100
#   },
#   "carrots"=> {
#     "price"=> 33.1/100,
#     "yield"=> 342.0*100
#   },
#   "cauliflower"=> {
#     "price"=> 46.0/100,
#     "yield"=> 186.0*100
#   },
#   "celery"=> {
#     "price"=> 20.0/100,
#     "yield"=> 636.0*100
#   },
#   "mushrooms"=> {
#     "price"=> 7.79/6.55,
#     "yield"=> 6.55*43560
#   },
#   "cucumbers"=> {
#     "price"=> 26.6/100,
#     "yield"=> 184.0*100
#   },
#   "eggplant"=> {
#     "price"=> 25.1/100,
#     "yield"=> 291.0*100
#   },
#   "escarole & endive"=> {
#     "price"=> 29.5/100,
#     "yield"=> 180.0*100
#   },
#   "garlic"=> {
#     "price"=> 68.2/100,
#     "yield"=> 163.0*100
#   },
#   "collard greens"=> {
#     "price"=> 21.6/100,
#     "yield"=> 119.0*100
#   },
#   "lettuce"=> {
#     "price"=> 23.1/100,
#     "yield"=> 366.0*100
#   },
#   "cantaloupe"=> {
#     "price"=> 18.6/100,
#     "yield"=> 236.0*100
#   },
#   "okra"=> {
#     "price"=> 46.1/100,
#     "yield"=> 60.0*100
#   },
#   "onions"=> {
#     "price"=> 11.2/100,
#     "yield"=> 523.0*100
#   },
#   "peas"=> {
#     "price"=> 399.0/2000,
#     "yield"=> 1.93*2000
#   },
#   "bell peppers"=> {
#     "price"=> 38.9/100,
#     "yield"=> 330.0*100
#   },
#   "pumpkins"=> {
#     "price"=> 10.6/100,
#     "yield"=> 266.0*100
#   },
#   "radishes"=> {
#     "price"=> 38.9/100,
#     "yield"=> 92.0*100
#   },
#   "spinach"=> {
#     "price"=> 40.5/100,
#     "yield"=> 158.0*100
#   },
#   "squash"=> {
#     "price"=> 38.1/100,
#     "yield"=> 149.0*100
#   },
#   "sweet corn"=> {
#     "price"=> 26.6/100,
#     "yield"=> 118.0*100
#   },
#   "tomatoes"=> {
#     "price"=> 42.5/100,
#     "yield"=> 280.0*100
#   },
#   "apples"=> {
#     "price"=> 0.383,
#     "yield"=> 34400.0
#   },
#   "strawberries"=> {
#     "price"=> 82.9/100,
#     "yield"=> 505.0*100
#   }
# }

# rand(1500..2000).times do
#   farmer = Farmer.create(name: Faker::Name.first_name)
#   Farm.create(farmer_id: farmer.id)
# end

# if Farmer.count.even?
#   farmer = Farmer.create(name: Faker::Name.first_name)
#   Farm.create(farmer_id: farmer.id)
# end

# rand(150..200).times do
#   Client.create(name: Faker::Company.name + " #{Faker::Company.suffix}" * rand(2),
#              revenue: Math.exp(rand(11..16)))
# end

# price_hash = {}
# crops.each do |crop, hash|
#   Crop.create(name: crop, yield: hash["yield"])
#   price_hash[crop] = hash["price"]
# end

# last_contract_id = 0
# end_of_2013 = Date.new(2013,12,31)
# last_friday_2013 = end_of_2013
# last_friday_2013 -= 1 until last_friday_2013.friday?
# beginning_of_2016 = Date.new(2016)
# first_monday_2016 = beginning_of_2016
# first_monday_2016 += 1 until first_monday_2016.monday?

# Client.all.each do |client|
#   starting_revenue = client.revenue
#   available_revenue = starting_revenue
#   loop do
#     contract_total = rand(0.0025..0.01) * starting_revenue
#     break unless (contract_total < available_revenue || client.id == 130)
#     crop = Crop.all.sample
#     contract_price = rand(0.75..1.25) * price_hash[crop.name]
#     contract_weight = contract_total / contract_price
#     farmer = Farmer.all.sample
#     if (last_contract_id % 500).zero?
#       contract = Contract.create(weight: contract_weight,
#                                   price: contract_price,
#                                   start: rand(last_friday_2013..Date.new(2014)),
#                                  finish: rand(Date.new(2016)..first_monday_2016),
#                               farmer_id: farmer.id,
#                               client_id: client.id,
#                                 crop_id: crop.id)
#     else
#       contract = Contract.create(weight: contract_weight,
#                                   price: contract_price,
#                                   start: rand(3.years.ago.to_date..Date.today),
#                                  finish: rand(1.year.from_now.to_date..3.years.from_now.to_date),
#                               farmer_id: farmer.id,
#                               client_id: client.id,
#                                 crop_id: crop.id)
#     end

#     last_contract_id = contract.id
#     available_revenue -= contract_total

#     field_size = contract_weight / crop.yield
#     field_upkeep = rand(0.6..0.9) * contract_total
#     farm = farmer.farm
#     Field.create(size: field_size,
#                upkeep: field_upkeep,
#               farm_id: farm.id,
#               crop_id: crop.id)
#     break if (available_revenue < 0 && client.id == 130)
#   end
# end

# Farmer.all.each do |farmer|
#   farm = farmer.farm
#   contracts_revenue = farmer.contracts.sum("price * weight")
#   fields_cost = farm.fields.sum(:upkeep)
#   farm_maintenance = farmer.id == 1069 ? (rand(1.1..1.2) * (contracts_revenue - fields_cost)) : (rand(0.5..0.8) * (contracts_revenue - fields_cost))
#   farm.update(maintenance: farm_maintenance)
# end

# env_descrip =
# """
# This problem set involves the ActiveRecord models |~Farmer|, |~Farm|, |~Crop|, |~Field|, |~Client|, and |~Contract|.

# The database tables |@crops| and |@contracts| are seeded based on the USDA's latest yields and market prices for a variety of crops.

# |@clients| is seeded with |*revenue| with which to negotiate |~Contract|s.

# Every |~Contract| |#join|ing a |~Farmer| and a |~Client| includes a single |~Crop|,
# |*weight| in lbs required annually, the negotiated |price| to be paid in $ per lb, a |*start| |%Date|,
# and a |*finish| |%Date|.

# |~Farmer|s in turn plant |~Crop|s on their |&farm| in |~Field|s which will be harvested once every year.

# Only one |~Crop| is planted on each |~Field|, and each |~Field| is |*size|d to |*yield| the |*weight| of its |&crop|
# required by its |&crop|'s |&contract|.

# Each |~Field| costs a fixed |*upkeep| to maintain based on its |*size| and the market price of its |&crop|.

# In addition to the |*upkeep| of their |&farm|'s |&fields|, every |~Farmer| must acquire the cost of |*maintenance| of its |&farm|
# """
# old_mac = Environment.create(
#   title: "old MacDonald |#has_one| |~Farm|",
#   description: env_descrip[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   models: { "Farmer"=>"farmer.rb", "Farm"=>"farm.rb", "Crop"=>"crop.rb", "Field"=>"field.rb", "Client"=>"client.rb", "Contract"=>"Contract.rb" }.to_json)

# prob_instruct =
# """
# In the magical realm of |?SQL|ville, the terms of each |~Contract| remain the same year to year (as does every other value stored) and are never broken.
# Each |~Contract| may last 1 year (harvest) or longer. Which |~Contract|s were negotiated to |*start| after the last Friday of 2013 |?AND| |*finish| before the first Monday
# of 2016?

# Complete the |%solution| method so that it returns an array of ActiveRecord |~Contract| objects representing those that |*start|
# |?AND| |*finish| in the range of |%Date|s provided, |#order|ed by earliest |*start| |%Date|.
# """
# def answer_technically_3_years
#   end_of_2013 = Date.new(2013,12,31)
#   last_friday_2013 = end_of_2013
#   last_friday_2013 -= 1 until last_friday_2013.friday?
#   beginning_of_2016 = Date.new(2016)
#   first_monday_2016 = beginning_of_2016
#   first_monday_2016 += 1 until first_monday_2016.monday?

#   Contract.where("start > '#{last_friday_2013}' and finish < '#{first_monday_2016}'").order(:start)
# end
# technically_3_years = old_mac.problems.create(
#   title: "technically 3 years",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_technically_3_years).to_json)

# prob_instruct =
# """
# A 'booming' |~Crop| is one that |#has_many| |&contracts| and |&fields|. Which |~Crop| was involved in the highest number of |~Contract|s?
# Which |~Crop| was planted over the greatest acreage?

# Complete the |%solution| method so that it returns an array of the |*name|s of the two ActiveRecord |~Crop| objects representing the |~Crop| with the greatest
# |#count| of |&contracts| and the |~Crop| with the greatest |#sum|med |*size| of its |&fields| in the following format:

# |%[||`most_contracts_crop_name||%,| |`greatest_acreage_crop_name||%]|
# """
# def answer_bandwagon_crops
#   most_contracts_crop_name = Crop.select("crops.*, COUNT(contracts.id) AS contracts_count").joins(:contracts).group(:id).order("contracts_count DESC").take.name
#   greatest_acreage_crop_name = Crop.select("crops.*, SUM(fields.size) AS total_acreage").joins(:fields).group(:id).order("total_acreage DESC").take.name

#   [most_contracts_crop_name, greatest_acreage_crop_name]
# end
# bandwagon_crops = old_mac.problems.create(
#   title: "bandwagon |~Crop|s",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_bandwagon_crops).to_json)

# prob_instruct =
# """
# Weary of his relentless success, Smitty W has decided to get away from it all to visit his old rural stomping grounds and catch up with his cousin.
# Although their family has a rich history of being the best, it appears the leftover mediocrity was funneled into Smitty's cousin's |~Farm|ing operation.

# In terms of |~Contract| income, Smitty's cousin is by definition |#average|--an equal number of |~Farmer|s will make more money than them this year as will make less than them.
# If the money a |~Farmer| makes = the |#sum| of the money made from their |&contracts|, who is Smitty's cousin?

# Complete the |%solution| method so that it returns the |*name| of the ActiveRecord |~Farmer| object representing Smitty W's Cousin.
# """
# def answer_smitty_w
#   farmer_w_name = Farmer.select("farmers.*, SUM(contracts.price * contracts.weight) AS total_income").joins(:contracts).group(:id).order("total_income DESC").offset(Farmer.count / 2).take.name
# end
# smitty_w = old_mac.problems.create(
#   title: "old |~Farmer| Werbenjagermanjensen",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_smitty_w).to_json)

# prob_instruct =
# """
# El Niño + paleo-preaching tabloids = a great time to grow and sell |~Crop|s. All |~Farmer|s and |~Client|s of the |@farmers| and |@clients|
# tables are expected to profit this year. All, that is, except for one deplorable duo of database (I tried) instances.

# A profitable |~Client| will have enough |*revenue| to cover the |#sum| of the costs of its |&contracts|.

# A profitable |~Farmer| will cover the |#sum| of the |*upkeep| costs of all the |~Field|s on their |&farm| plus its cost of |*maintenance| with the |#sum| of the money made from their |&contracts|.

# Complete the |%solution| method so that it returns an array of the |*name|s of two ActiveRecord objects representing the |~Farmer|
# and |~Client| who will not profit this year in the following format:

# |%[||`unprofitable_client_name||%,| |`unprofitable_farmer_name||%]|
# """
# def answer_the_red_line
#   unprofitable_client_name = Client.select("clients.*, (SUM(contracts.price * contracts.weight) - revenue) AS profit").joins(:contracts).group(:id).order("profit").take.name

#   farmers_w_income = Farmer.select("farmers.*, SUM(contracts.price * contracts.weight) AS total_income").joins(:contracts).group(:id).order(:id)
#   farms_w_upkeep = Farm.select("farms.*, SUM(fields.upkeep) AS total_upkeep").joins(:fields).group(:id).order(:farmer_id)

#   farmers_w_income.each_with_index do |farmer, index|
#     farm = farms_w_upkeep[index]
#     profit = farmer.total_income - farm.total_upkeep - farm.maintenance
#     if profit < 0
#       unprofitable_farmer_name = farmer.name
#       return [unprofitable_client_name, unprofitable_farmer_name]
#     end
#   end
# end
# the_red_line = old_mac.problems.create(
#   title: "the red line and the black thumb",
#   instructions: prob_instruct[1..-2].gsub(/\n/," ").gsub(/  /,"\n\n"),
#   answer: Array.wrap(answer_the_red_line).to_json)

# raw_avg_household =
# """
# def solution
#   Person.where(:children_count=> [1, 2]).order(:name)
# end

# solution
# """
# raw_avg_household = raw_avg_household[1..-2]

# raw_brady_bunch =
# """
# def solution
#   mike_brady = Person.find_by({ name: \"Mike\", children_count: 6, yob: 1932 })
#   carol_brady = mike_brady.spouse
#   brady_bunch = mike_brady.children.order(yob: :desc).map{ |brady_child|  brady_child }
#   if mike_brady.yob > carol_brady.yob
#     brady_bunch << mike_brady << carol_brady
#   else
#     brady_bunch << carol_brady << mike_brady
#   end
#   brady_bunch
# end

# solution
# """
# raw_brady_bunch = raw_brady_bunch[1..-2]

# raw_bachelor =
# """
# def solution
#   all_singles = Person.where(spouse_id: nil)
#   gens_with_singles = all_singles.pluck(:generation).uniq
#   gens_with_singles.each do |gen|
#     genders_of_singles = all_singles.where(generation: gen).pluck(:gender)
#     m_and_f_available = genders_of_singles.uniq.size == 2 ? true : false
#     if m_and_f_available
#       if genders_of_singles.count(\"F\") > 1
#         the_bachelor = all_singles.find_by({ generation: gen, gender: \"M\" })
#         return the_bachelor
#       else
#         the_bachelorette = all_singles.find_by({ generation: gen, gender: \"F\" })
#         return the_bachelorette
#       end
#     end
#   end
#   return \"no bachelor(ette)s!\"
# end

# solution
# """
# raw_bachelor = raw_bachelor[1..-2]

# raw_lazy_parents =
# """
# def solution
#   children_gens = [1, 2, 3, 4]
#   laziest_parents = children_gens.map do |gen|
#     max_freq_child = Person.where(generation: gen).order(frequency: :desc).take
#     [max_freq_child.mother, max_freq_child.father]
#   end
#   laziest_parents.flatten
# end

# solution
# """
# raw_lazy_parents = raw_lazy_parents[1..-2]

# raw_technicaly_3_years =
# """
# def solution
#   end_of_2013 = Date.new(2013,12,31)
#   last_friday_2013 = end_of_2013
#   last_friday_2013 -= 1 until last_friday_2013.friday?
#   beginning_of_2016 = Date.new(2016)
#   first_monday_2016 = beginning_of_2016
#   first_monday_2016 += 1 until first_monday_2016.monday?

#   Contract.where(\"start > '#{last_friday_2013}' and finish < '#{first_monday_2016}'\").order(:start)
# end

# solution
# """
# raw_technicaly_3_years = raw_technicaly_3_years[1..-2]

# raw_bandwagon_crops =
# """
# def solution
#   most_contracts_crop_name = Crop.select(\"crops.*, COUNT(contracts.id) AS contracts_count\").joins(:contracts).group(:id).order(\"contracts_count DESC\").take.name
#   greatest_acreage_crop_name = Crop.select(\"crops.*, SUM(fields.size) AS total_acreage\").joins(:fields).group(:id).order(\"total_acreage DESC\").take.name

#   [most_contracts_crop_name, greatest_acreage_crop_name]
# end

# solution
# """
# raw_bandwagon_crops = raw_bandwagon_crops[1..-2]

# raw_smitty_w =
# """
# def solution
#   farmer_w_name = Farmer.select(\"farmers.*, SUM(contracts.price * contracts.weight) AS total_income\").joins(:contracts).group(:id).order(\"total_income DESC\").offset(Farmer.count / 2).take.name
# end

# solution
# """
# raw_smitty_w = raw_smitty_w[1..-2]

# raw_the_red_line =
# """
# def solution
#   unprofitable_client_name = Client.select(\"clients.*, (SUM(contracts.price * contracts.weight) - revenue) AS profit\").joins(:contracts).group(:id).order(\"profit\").take.name

#   farmers_w_income = Farmer.select(\"farmers.*, SUM(contracts.price * contracts.weight) AS total_income\").joins(:contracts).group(:id).order(:id)
#   farms_w_upkeep = Farm.select(\"farms.*, SUM(fields.upkeep) AS total_upkeep\").joins(:fields).group(:id).order(:farmer_id)

#   farmers_w_income.each_with_index do |farmer, index|
#     farm = farms_w_upkeep[index]
#     profit = farmer.total_income - farm.total_upkeep - farm.maintenance
#     if profit < 0
#       unprofitable_farmer_name = farmer.name
#       return [unprofitable_client_name, unprofitable_farmer_name]
#     end
#   end
# end

# solution
# """
# raw_the_red_line = raw_the_red_line[1..-2]

# admin = User.create(name: "tastyham", password: "taoontop", password_confirmation: "taoontop", admin: true, email: "example@example.com")
