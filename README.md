#### Getting Started

```bash
git clone git repo
cd into git repo
```

#### Requirements

You'll need the following installed to run the app successfully:

* Ruby 3.0 or higher
* bundler - `gem install bundler`
* Redis - For ActionCable support (and Sidekiq, caching, etc)
* PostgreSQL - `brew install postgresql`
* Imagemagick - `brew install imagemagick`
* Yarn - `brew install yarn` or [Install Yarn](https://yarnpkg.com/en/docs/install)
* Foreman (optional) - `gem install foreman` - helps run all your
  processes in development

#### Initial Setup

Next, run `bin/setup` to install Rubygem and Javascript dependencies.

```bash
bin/setup
```

```bash
rails db:migrate
```

To run your application, you'll use the `bin/dev` command:

```bash
bin/dev
```

Then open http://localhost:3000


#### Cron

App uses the Whenever gem to run rake tasks.
 
* Currently, there is only one rake task that runs every hour to retrive any new stories and adds them to the database.


Run the following command in your terminal to update your crontab 

```bash
whenever --update-crontab
```

To view your crontab entries run the following

```bash
crontab -l
```

If you want to remove a specifc crontab entry run the following

```bash
crontab -e
```

or 

```bash
export EDITOR=nano; crontab -e
```

#### Notes

* Errors are being added to log. However, if using 3rd party application like AppSignal we can send errors there.
* Rake task currently calls the service objeects directly.  We could refactor to have one job that calls others after its complete.