# Generated by Django 3.0.8 on 2020-07-07 07:01

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Employee',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('first_name', models.CharField(max_length=250)),
                ('last_name', models.CharField(max_length=250)),
                ('slug', models.SlugField(max_length=250)),
                ('job_description', models.TextField(verbose_name='')),
                ('publish', models.DateTimeField(default=django.utils.timezone.now)),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('updated', models.DateTimeField(auto_now=True)),
                ('status', models.CharField(choices=[('billable', 'Billable'), ('bench', 'bench')], default='billable', max_length=10)),
                ('icon', models.ImageField(blank=True, default='imgs/default-user.png', upload_to='profile_image/')),
            ],
            options={
                'ordering': ('-publish',),
            },
        ),
    ]
