require 'test/unit'
require 'pathname'
require 'fileutils'

=begin
Updating functional testdata automatically is DANGEROUS, so I do manually.

== update functional test
cd ~/src/rcov/test
rcov="ruby ../bin/rcov -I../lib:../ext/rcovrt -o expected_coverage"

$rcov -a sample_04.rb
$rcov sample_04.rb
$rcov --gcc --include-file=sample --exclude=rcov sample_04.rb > expected_coverage/gcc-text.out

cp sample_05-old.rb sample_05.rb
$rcov --no-html --gcc --include-file=sample --exclude=rcov --save=coverage.info sample_05.rb > expected_coverage/diff-gcc-original.out
cp sample_05-new.rb sample_05.rb
$rcov --no-html --gcc -D --include-file=sample --exclude=rcov sample_05.rb > expected_coverage/diff-gcc-diff.out
$rcov --no-html -D --include-file=sample --exclude=rcov sample_05.rb > expected_coverage/diff.out
$rcov --no-html --no-color -D --include-file=sample --exclude=rcov sample_05.rb > expected_coverage/diff-no-color.out
$rcov --no-html --gcc --include-file=sample --exclude=rcov sample_05.rb > expected_coverage/diff-gcc-all.out
  
=end

class TestFunctional < Test::Unit::TestCase
  @@dir = Pathname(__FILE__).expand_path.dirname

  def strip_time(str)
    str.sub(/Generated on.+$/, '')
  end

  def cmp(file)
    content = lambda{|dir| strip_time(File.read(@@dir+dir+file))}
    assert_equal(content["expected_coverage"], content["actual_coverage"])
  end

  def with_testdir(&block)
    Dir.chdir(@@dir, &block)
  end

  def run_rcov(opts, script="sample_04.rb", opts_tail="")
    rcov = @@dir+"../bin/rcov"
    ruby_opts = "-I../lib:../ext/rcovrt"
    with_testdir do
      `cd #{@@dir}; ruby #{ruby_opts} #{rcov} #{opts} -o actual_coverage #{script} #{opts_tail}`
      yield if block_given?
    end
  end

  def test_annotation
    run_rcov("-a") do
      cmp "sample_04_rb.rb"
      cmp "sample_03_rb.rb"
    end
  end

  def test_html
    run_rcov("") do
      cmp "sample_04_rb.html"
      cmp "sample_03_rb.html"
    end
  end

  @@selection = "--include-file=sample --exclude=rcov"
  def test_text_gcc
    run_rcov("--gcc #{@@selection}",
             "sample_04.rb",
             "> actual_coverage/gcc-text.out") do
      cmp "gcc-text.out"
    end
  end

  def test_diff
    with_testdir { FileUtils.cp "sample_05-old.rb", "sample_05.rb" }
    run_rcov("--no-html --gcc #{@@selection} --save=coverage.info", "sample_05.rb",
             "> actual_coverage/diff-gcc-original.out") do
      cmp "diff-gcc-original.out"
    end

    with_testdir { FileUtils.cp "sample_05-new.rb", "sample_05.rb" }
    run_rcov("--no-html -D --gcc #{@@selection}", "sample_05.rb",
             "> actual_coverage/diff-gcc-diff.out") do
      cmp "diff-gcc-diff.out"
    end

    run_rcov("--no-html -D #{@@selection}", "sample_05.rb",
             "> actual_coverage/diff.out") do
      cmp "diff.out"
    end

    run_rcov("--no-html --no-color -D #{@@selection}", "sample_05.rb",
             "> actual_coverage/diff-no-color.out") do
      cmp "diff-no-color.out"
    end

    run_rcov("--no-html --gcc #{@@selection}", "sample_05.rb",
             "> actual_coverage/diff-gcc-all.out") do
      cmp "diff-gcc-all.out"
    end

    
  end

end
